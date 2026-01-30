class MatchesController < ApplicationController
  before_action :set_search

  def index
    @search = Search.find(params[:search_id])
    @comparison_products = ComparisonProduct.includes(:brand)
      .by_clothing_item(params[:clothing_item])
      .by_clothing_colour(params[:clothing_colour])
      .by_clothing_material(params[:clothing_material])
      .by_overall_rating(params[:overall_rating])

    product_ids = @comparison_products.pluck(:id)
    @matches_by_product_id = @search.matches
      .where(comparison_product_id: product_ids)
      .index_by(&:comparison_product_id)
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
