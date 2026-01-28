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
      redirect_back(fallback_location: search_matches_path(@search), notice: "Product saved to wishlist!")
    else
      redirect_back(fallback_location: search_matches_path(@search), alert: @wishlist_item.errors.full_messages.first || "Could not save to wishlist.")
    end
  end

  def destroy
    @wishlist_item = current_user.wishlist_items.find_by(match_id: @match.id)
    
    if @wishlist_item&.destroy
      redirect_back(fallback_location: search_matches_path(@search), notice: "Product removed from wishlist!")
    else
      redirect_back(fallback_location: search_matches_path(@search), alert: "Could not remove from wishlist.")
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
