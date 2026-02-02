class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search, only: [:show, :edit, :update]

  def new
    @search = Search.new
  end

  def create
    @search = Search.new(search_params)
    @search.user = current_user
    @search.system_prompt = build_system_prompt(@search)

    if @search.save
      if @search.uploaded_image.attached?
        # Use LLM for image analysis
        @chat = RubyLLM.chat(model: "gpt-4o").with_instructions(@search.system_prompt)
        @response = @chat.ask("Analyze this clothing item and return the JSON.", with: { image: @search.uploaded_image.url })
        @raw_response = @response.content #!!!Just for testing, remove after
        # Strip markdown code blocks if present (```json ... ```)
        json_content = @response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
        parsed = JSON.parse(json_content) rescue nil

      else
        # Use ScrapingBee to extract basic data, then GPT-4o to analyze
        Rails.logger.info "DEBUG: Using ScrapingBee for link: #{@search.uploaded_link}"
        # Calling the send_request method with the URL to fetch page data, returns hash or nil stored in the variable
        scraped_data = ScrapingBeeApi.new.send_request(@search.uploaded_link)
        #.inspect shows the full hash contents in the logs - great for seeing exactly what data came back
        Rails.logger.info "DEBUG: ScrapingBee returned: #{scraped_data.inspect}"

        if scraped_data
          # Use GPT-4o to analyze the scraped data and extract clothing details
          # Calling a helper method that creates a text prompt like
          analysis_prompt = build_link_analysis_prompt(scraped_data)
          @chat = RubyLLM.chat(model: "gpt-4o") #Creates a chat session with GPT-4o
          @response = @chat.ask(analysis_prompt) #Sends our prompt and waits for a response
          @raw_response = @response.content #!!!Just for testing, remove after
          Rails.logger.info "DEBUG: GPT-4o response: #{@response.content}"

          # Parse the JSON response
          json_content = @response.content.gsub(/```json\s*/, '').gsub(/```\s*/, '').strip
          parsed = JSON.parse(json_content) rescue nil #Converts JSON string → Ruby hash; if parsing fails, return nil instead of crashing

          # Merge with scraped data (keep scraped image/name/description if GPT didn't provide)
          # The ||= operator means "assign only if currently nil/empty".
          if parsed
            parsed["item_image"] ||= scraped_data["item_image"]
            parsed["item_name"] ||= scraped_data["item_name"]
            parsed["item_description"] ||= scraped_data["item_description"]
          end
        else
          parsed = nil
        end
      end

      # Update search with parsed data
      if parsed
        update_attrs = {
          clothing_item: parsed["clothing_item"],
          clothing_material: parsed["clothing_material"],
          clothing_colour: normalize_colour(parsed["clothing_colour"]),
          clothing_brand: parsed["clothing_brand"],
          clothing_price: parsed["clothing_price"],
          item_name: parsed["item_name"],
          item_description: parsed["item_description"]
        }

        if @search.uploaded_image.attached?
          # Get Cloudinary URL and save to both uploaded_image (string column) and item_image
          cloudinary_url = @search.uploaded_image.url
          update_attrs[:item_image] = cloudinary_url
          @search.update(update_attrs)
          # Use update_column to bypass Active Storage and write directly to the string column
          @search.update_column(:uploaded_image, cloudinary_url)
        else
          # Use scraped image URL for link uploads
          item_image = parsed["item_image"]
          item_image = item_image.first if item_image.is_a?(Array)
          update_attrs[:item_image] = item_image
          @search.update(update_attrs)
        end
      end
      redirect_to search_matches_path(@search), notice: "Search completed."
      # render :new #!!!for testing, remove after and change to the code above
    else
      render 'pages/home', status: :unprocessable_entity, notice: "Error creating search."
    end
  end

  ######## 2 PROMPTS INSTEAD OF 1 #############
  #why? easy to isolate issues, changing one does not affect the other, less complex instructions and confusing conditionals

  #1.build_link_analysis_prompt
  ##INPUT: Text (scraped data)
  ##GPT 40:	"Read this product info"
  ##DATA: ScrapingBee extracted text
  #USAGE: when uploaded_link is provided


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

  #2.build_system_prompt
  ##INPUT: Image (visual)
  ##GPT 40: "Look at this picture"
  ##DATA: Cloudinary URL
  #USAGE: when uploaded_image.attached? is true

  def build_system_prompt(search)
    input_type_text = if search.uploaded_image.attached?
      "I am providing you with an image of a clothing item to analyze."
    else
      "I am providing you with a link to a product page: #{search.uploaded_link}.
       Extract details from the page content and any visible product images."
    end

    <<~PROMPT
      You are an expert fashion analyst helping identify clothing items and their more sustainable alternatives.

      #{input_type_text}

      Analyze the clothing item and extract the following details:
      - clothing_item: the type of garment (e.g., t-shirt, jeans, dress, jacket)
      - clothing_material: the fabric or material if identifiable (e.g., cotton, polyester, wool)
      - clothing_colour: the primary color(s)
      - clothing_brand: the brand name if visible or identifiable
      - clothing_price: the price as a numeric value without currency symbol
      - item_name: the product name if available
      - item_description: a brief description of style, fit, and notable features
      - item_image: the product image URL (only if analyzing a link)

       IMPORTANT - Normalize values to generic categories:

      For clothing_item: Use base garment type only. Strip style modifiers. For example:
      - "barrel leg jeans", "skinny jeans", "bootcut jeans" → "jeans"
      - "oversized hoodie", "cropped hoodie" → "hoodie"
      - "maxi dress", "midi dress", "wrap dress" → "dress"
      - "bomber jacket", "denim jacket" → "jacket"

      For clothing_colour: ALWAYS use a single base color from this list: black, white, grey, blue, red, green, yellow, orange, pink, purple, brown, beige, multicolor.
      NEVER include shade modifiers like "light", "dark", "navy", "royal", etc. Examples:
      - "light blue", "dark blue", "navy blue", "royal blue", "sky blue", "dark denim" → "blue"
      - "light green", "dark green", "forest green", "sage green", "olive", "mint" → "green"
      - "light pink", "hot pink", "blush", "rose" → "pink"
      - "burgundy", "wine", "maroon", "crimson", "scarlet" → "red"
      - "cream", "ivory", "off-white", "eggshell" → "white"
      - "charcoal", "graphite", "slate", "light grey", "dark grey" → "grey"
      - "tan", "camel", "khaki", "taupe" → "beige"

      For clothing_material: Use primary material only. For example:
      - "100% organic cotton" → "cotton"
      - "recycled polyester blend" → "polyester"

      Return ONLY valid JSON with this exact structure:
      {
        "clothing_item": "value or null",
        "clothing_material": "value or null",
        "clothing_colour": "value or null",
        "clothing_brand": "value or null",
        "clothing_price": "number or null",
        "item_name": "value or null",
        "item_description": "value or null",
        "item_image": "url or null"
      }

      If any field cannot be determined, use null. Return ONLY the JSON, no additional text.
    PROMPT
  end


  def show
  end

  def edit
  end

  def update
    if @search.update(search_params)
      redirect_to search_path(@search), notice: "Search updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_search
    @search = Search.find(params[:id])
  end

  def normalize_colour(colour)
    return nil if colour.blank?

    colour = colour.downcase.strip

    colour_map = {
      "blue" => %w[blue navy light\ blue dark\ blue sky\ blue royal\ blue baby\ blue cobalt denim \light wash],
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

  def search_params
    params.require(:search).permit(
      :uploaded_image,
      :uploaded_link
    )
  end
end
