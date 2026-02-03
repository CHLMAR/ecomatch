class MatchesController < ApplicationController
  before_action :set_search

  def index
    @search = Search.find(params[:search_id])
    @brand_info = @search.clothing_brand.present? ? Brand.find_by("LOWER(name) = ?", @search.clothing_brand.strip.downcase) : nil

    # If clear param is present, show all products (no filters)
    # If commit param is present (form submitted), use filter params
    # Otherwise (initial load), prepopulate with search values
    if params[:clear].present?
      clothing_item = nil
      clothing_colour = nil
    elsif params[:commit].present?
      clothing_item = params[:clothing_item]
      clothing_colour = params[:clothing_colour]
    else
      clothing_item = params[:clothing_item].presence || @search.clothing_item
      clothing_colour = params[:clothing_colour].presence || @search.clothing_colour
    end

    @comparison_products = ComparisonProduct.includes(:brand)
      .by_clothing_item(clothing_item)
      .by_clothing_colour(clothing_colour)
      .by_clothing_material(params[:clothing_material])
      .by_overall_rating(params[:overall_rating])
      # adding ordering by brand overall rating descending
      .joins(:brand).order("brands.overall_rating DESC")
  end

  def show_product
    comparison_product = ComparisonProduct.find(params[:id])
    match = @search.matches.find_or_create_by(comparison_product: comparison_product) do |m|
      m.similarities = "Matched via product view"
    end
    redirect_to search_match_path(@search, match)
  end

  def show
    @match = @search.matches.includes(comparison_product: :brand).find(params[:id])

    if @match.comparison_product.blank?
      redirect_to search_matches_path(@search), alert: "Content not available."
      return
    end

    @comparison_product = @match.comparison_product
    @matches = @search.matches.includes(comparison_product: :brand)

    # Find similar products based on clothing item type, excluding the current product
    @similar_products = ComparisonProduct.includes(:brand)
      .where(clothing_item: @comparison_product.clothing_item)
      .where.not(id: @comparison_product.id)
      .limit(6)
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end
end
