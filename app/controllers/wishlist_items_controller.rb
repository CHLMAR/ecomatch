class WishlistItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_search, only: [:create]
  before_action :set_match, only: [:create]

  def create
    @wishlist_item = current_user.wishlist_items.build(
      match: @match,
      comparison_product: @match.comparison_product
    )

    if @wishlist_item.save
      # If coming from wishlist page, redirect back there. Otherwise go to matches page.
      if request.referer&.include?('/wishlist')
        redirect_to wishlist_user_path(current_user), notice: "Product saved to wishlist!"
      else
        redirect_to search_matches_path(@search), notice: "Product saved to wishlist!"
      end
    else
      # Same redirect logic for errors
      if request.referer&.include?('/wishlist')
        redirect_to wishlist_user_path(current_user), alert: @wishlist_item.errors.full_messages.first || "Could not save to wishlist."
      else
        redirect_to search_matches_path(@search), alert: @wishlist_item.errors.full_messages.first || "Could not save to wishlist."
      end
    end
  end

  def destroy
    # Find the wishlist_item to delete
    @wishlist_item = if params[:search_id].present?
      # Coming from matches page - find by match_id
      @search = Search.find(params[:search_id])
      @match = @search.matches.find(params[:id])
      current_user.wishlist_items.find_by(match_id: @match.id)
    else
      # Coming from wishlist page - find by wishlist_item id
      # Use params[:user_id] from the route, not current_user
      user = User.find(params[:user_id])
      user.wishlist_items.find(params[:id])
    end

    # Delete the item
    if @wishlist_item&.destroy
      # Redirect based on where we came from
      if params[:search_id].present?
        # Stay on matches page
        redirect_to search_matches_path(@search), notice: "Product removed from wishlist!"
      else
        # Go back to wishlist page
        redirect_to wishlist_user_path(params[:user_id]), notice: "Product removed from wishlist!"
      end
    else
      # Error handling - redirect based on where we came from
      if params[:search_id].present?
        redirect_to search_matches_path(@search), alert: "Could not remove from wishlist."
      else
        redirect_to wishlist_user_path(params[:user_id]), alert: "Could not remove from wishlist."
      end
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
