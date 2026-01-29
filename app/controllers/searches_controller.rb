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
        # Use ScrapingBee for link analysis
        parsed = ScrapingBeeApi.new.send_request(@search.uploaded_link)
        @raw_response = parsed.to_json #!!!Just for testing, remove after
      end
      
      # Update search with parsed data
      if parsed
        @search.update(
          clothing_item: parsed["clothing_item"],
          clothing_material: parsed["clothing_material"],
          clothing_colour: parsed["clothing_colour"],
          clothing_brand: parsed["clothing_brand"],
          clothing_price: parsed["clothing_price"],
          item_name: parsed["item_name"],
          item_description: parsed["item_description"],
          item_image: parsed["item_image"]
        )
      end
      # redirect_to search_path(@search), notice: "Search completed."
      render :new #!!!for testing, remove after and change to the code above
    else
      render :new, status: :unprocessable_entity
    end
  end


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

  def search_params
    params.require(:search).permit(
      :uploaded_image,
      :uploaded_link
    )
  end
end
