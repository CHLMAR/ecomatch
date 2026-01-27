class WishlistItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search
  before_action :set_match

  def create
    @wishlist_item = current_user.wishlist_items.build(
      match: @match,
      comparison_product: @match.comparison_product
    )

    if @wishlist_item.save
      redirect_to search_matches_path(@search), notice: "Product saved to wishlist!"
    else
      redirect_to search_matches_path(@search), alert: @wishlist_item.errors.full_messages.first || "Could not save to wishlist."
    end
  end

  private

  def set_search
    @search = Search.find(params[:search_id])
  end

  def set_match
    @match = @search.matches.find(params[:id])
  end
end
