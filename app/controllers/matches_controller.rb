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
