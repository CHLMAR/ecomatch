class MatchesController < ApplicationController
  before_action :set_search

  def index
    @matches = @search.matches.includes(comparison_product: :brand)
  end

  def show
    @match = @search.matches.includes(comparison_product: :brand).find(params[:id])
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end
end
