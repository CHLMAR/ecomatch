# frozen_string_literal: true

# Flow:
# 1. User submits search form
# 2. Controller saves search with status "processing" and enqueues this job
# 3. User sees processing page with cycling brand logos
# 4. This job runs, calls AI APIs, updates the search record
# 5. Job broadcasts Turbo Stream to trigger redirect to results

class SearchAnalysisJob < ApplicationJob
  queue_as :default

  def perform(search_id)
    search = Search.find(search_id)

    begin
      # Perform the analysis based on input type (image or link)
      if search.uploaded_image.attached?
        analyze_image(search)
      else
        analyze_link(search)
      end

      # Mark as completed and broadcast success
      search.update!(status: "completed")
      broadcast_completion(search)

    rescue StandardError => e
      # Log the error and broadcast failure
      Rails.logger.error "[SearchAnalysisJob] Failed for search ##{search_id}: #{e.message}"
      Rails.logger.error e.backtrace.join("\n")

      search.update!(status: "failed")
      broadcast_error(search, e.message)
    end
  end

  private

  # Analyze an uploaded image using GPT-4o vision
  def analyze_image(search)
    Rails.logger.info "[SearchAnalysisJob] Analyzing image for search ##{search.id}"

    chat = RubyLLM.chat(model: "gpt-4o").with_instructions(search.system_prompt)
    response = chat.ask(
      "Analyze this clothing item and return the JSON.",
      with: { image: search.uploaded_image.url }
    )

    json_content = response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
    parsed = JSON.parse(json_content) rescue nil

    if parsed
      update_search_with_parsed_data(search, parsed, image_upload: true)
    end
  end

  # Analyze a product link using ScrapingBee + GPT-4o
  def analyze_link(search)
    Rails.logger.info "[SearchAnalysisJob] Analyzing link for search ##{search.id}: #{search.uploaded_link}"

    # First, scrape the page content
    scraped_data = ScrapingBeeApi.new.send_request(search.uploaded_link)

    if scraped_data
      # Use GPT-4o to analyze the scraped content
      analysis_prompt = build_link_analysis_prompt(scraped_data)
      chat = RubyLLM.chat(model: "gpt-4o")
      response = chat.ask(analysis_prompt)

      json_content = response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
      parsed = JSON.parse(json_content) rescue nil

      if parsed
        # Merge with scraped data for fallbacks
        parsed["item_image"] ||= scraped_data["item_image"]
        parsed["item_name"] ||= scraped_data["item_name"]
        parsed["item_description"] ||= scraped_data["item_description"]

        update_search_with_parsed_data(search, parsed, image_upload: false)
      end
    end
  end

  # Update the search record with AI-analyzed data
  def update_search_with_parsed_data(search, parsed, image_upload:)
    update_attrs = {
      clothing_item: parsed["clothing_item"],
      clothing_material: parsed["clothing_material"],
      clothing_colour: normalize_colour(parsed["clothing_colour"]),
      clothing_brand: parsed["clothing_brand"],
      clothing_price: parsed["clothing_price"],
      item_name: parsed["item_name"],
      item_description: parsed["item_description"]
    }

    if image_upload
      # For uploaded images, use the Cloudinary URL
      cloudinary_url = search.uploaded_image.url
      update_attrs[:item_image] = cloudinary_url
      search.update!(update_attrs)
      search.update_column(:uploaded_image, cloudinary_url)
    else
      # For links, use the scraped/parsed image URL
      item_image = parsed["item_image"]
      item_image = item_image.first if item_image.is_a?(Array)
      update_attrs[:item_image] = item_image
      search.update!(update_attrs)
    end
  end

  # Broadcast Turbo Stream to signal completion
  # This replaces the processing view with a redirect trigger
  def broadcast_completion(search)
    Rails.logger.info "[SearchAnalysisJob] Broadcasting completion for search ##{search.id}"

    # Turbo::StreamsChannel.broadcast_replace_to broadcasts to ActionCable
    # The first argument is the stream name (matches stream_for in SearchChannel)
    # target: specifies which DOM element to replace
    # partial: the view partial to render
    Turbo::StreamsChannel.broadcast_replace_to(
      search,                              # Stream identifier (matches stream_for search)
      target: "search_processing",         # DOM element ID to replace
      partial: "searches/completed",       # Partial to render
      locals: { search: search }           # Variables passed to partial
    )
  end

  # Broadcast error state if processing fails
  def broadcast_error(search, error_message)
    Rails.logger.info "[SearchAnalysisJob] Broadcasting error for search ##{search.id}: #{error_message}"

    Turbo::StreamsChannel.broadcast_replace_to(
      search,
      target: "search_processing",
      partial: "searches/error",
      locals: { search: search, error_message: error_message }
    )
  end

  # Normalize color names to standard values for consistent matching
  def normalize_colour(colour)
    return nil if colour.blank?

    colour = colour.downcase.strip

    colour_map = {
      "blue" => %w[blue navy light\ blue dark\ blue sky\ blue royal\ blue baby\ blue cobalt denim light\ wash],
      "green" => %w[green olive sage mint forest\ green dark\ green light\ green emerald teal],
      "red" => %w[red burgundy wine maroon crimson scarlet cherry],
      "pink" => %w[pink blush rose hot\ pink light\ pink fuchsia magenta],
      "white" => %w[white cream ivory off-white eggshell],
      "grey" => %w[grey gray charcoal graphite slate silver],
      "black" => %w[black],
      "brown" => %w[brown chocolate espresso],
      "beige" => %w[beige tan camel khaki taupe nude sand],
      "yellow" => %w[yellow gold mustard],
      "orange" => %w[orange coral peach rust],
      "purple" => %w[purple violet lavender plum lilac]
    }

    colour_map.each do |base_colour, variants|
      return base_colour if variants.any? { |v| colour.include?(v) }
    end

    colour # Return original if no match found
  end

  # Build the analysis prompt for link-based searches
  def build_link_analysis_prompt(scraped_data)
    <<~PROMPT
      Analyze this product information and extract clothing details.

      Product Name: #{scraped_data['item_name']}
      Description: #{scraped_data['item_description']}
      Page Title: #{scraped_data['page_title']}

      Extract these fields:

      clothing_item: ONLY the garment type, NO colors or style modifiers.
        - "white t-shirt" → "t-shirt"
        - "blue skinny jeans" → "jeans"
        - "red maxi dress" → "dress"
        - "black leather jacket" → "jacket"

      clothing_colour: The color. Use ONLY: black, white, grey, blue, red, green, yellow, orange, pink, purple, brown, beige, multicolor

      clothing_material: The fabric if mentioned (cotton, polyester, denim, wool, etc.)

      clothing_brand: The brand name

      clothing_price: Price as number only, or null

      Return ONLY valid JSON, no markdown:
      {"clothing_item": "garment type only", "clothing_colour": "base color", "clothing_material": "fabric or null", "clothing_brand": "brand", "clothing_price": null}
    PROMPT
  end
end
