class SearchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search, only: [:show, :edit, :update, :processing]

  def index
    @user = User.find(params[:id])
    return head :forbidden unless current_user == @user

    @searches = @user.searches.order(created_at: :desc)
  end

  def new
    @search = Search.new
  end

  # CREATE - Now uses background job for AI processing

  # New flow (async, immediate response):
  #   1. Save search with status "processing"
  #   2. starets SearchAnalysisJob
  #   3. renders processing page immediately
  #   4. Job runs in background broadcasts Turbo Stream when done
  #   5. Browser receives stream & redirects to results

  def create
    @search = Search.new(search_params)
    @search.user = current_user
    @search.system_prompt = build_system_prompt(@search)
    @search.status = "processing"

    if @search.save
      SearchAnalysisJob.perform_later(@search.id)
      @brand_logos = Brand.where.not(logo: [nil, '']).where('overall_rating >= ?', 3).pluck(:name, :logo).shuffle
      # Render processing page
      render :processing
    else
      @top_brands = Brand.order(overall_rating: :desc).limit(7)
      render 'pages/home', status: :unprocessable_entity, notice: "Error creating search."
    end
  end

  def processing
    if @search.status == "completed"
      redirect_to search_matches_path(@search)
      return
    end

    if @search.status == "failed"
      flash[:alert] = "Search analysis failed. Please try again."
      redirect_to root_path
      return
    end

    @brand_logos = Brand.where.not(logo: [nil, '']).where('overall_rating >= ?', 3).pluck(:name, :logo).shuffle
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

  def search_params
    params.require(:search).permit(
      :uploaded_image,
      :uploaded_link
    )
  end
end
