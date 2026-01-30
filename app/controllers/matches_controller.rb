class MatchesController < ApplicationController
  before_action :set_search

  def index
    @search = Search.find(params[:search_id])
    @brand_info = @search.clothing_brand.present? ? Brand.find_by("LOWER(name) = ?", @search.clothing_brand.strip.downcase) : nil

    clothing_item = params[:commit] ? params[:clothing_item] : (params[:clothing_item].presence || @search.clothing_item)
    clothing_colour = params[:commit] ? params[:clothing_colour] : (params[:clothing_colour].presence || @search.clothing_colour)

    @comparison_products = ComparisonProduct.includes(:brand)
      .by_clothing_item(clothing_item)
      .by_clothing_colour(clothing_colour)
      .by_clothing_material(params[:clothing_material])
      .by_overall_rating(params[:overall_rating])
  end

  def show_product
    @comparison_product = ComparisonProduct.includes(:brand).find(params[:id])
    @similar_products = ComparisonProduct
      .by_clothing_item(@comparison_product.clothing_item)
      .where.not(id: @comparison_product.id)
      .includes(:brand)
      .limit(6)
  end

  def show
    @match = @search.matches.includes(comparison_product: :brand).find(params[:id])

    if @match.comparison_product.blank?
      redirect_to search_matches_path(@search), alert: "Content not available."
    end

    @matches = @search.matches.includes(comparison_product: :brand)
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end
end
