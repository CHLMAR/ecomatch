class ExploreController < ApplicationController
  before_action :authenticate_user!

  def index
    @comparison_products = ComparisonProduct.includes(:brand)
      .by_clothing_item(params[:clothing_item])
      .by_clothing_colour(params[:clothing_colour])
      .by_clothing_material(params[:clothing_material])
      .by_overall_rating(params[:overall_rating])
  end

  def show
    @comparison_product = ComparisonProduct.includes(:brand).find(params[:id])
    @similar_products = ComparisonProduct
      .by_clothing_item(@comparison_product.clothing_item)
      .where.not(id: @comparison_product.id)
      .includes(:brand)
      .limit(6)
  end
end
