class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:id])
    @wishlist_items = @user.wishlist_items.includes(:match, :comparison_product, match: :comparison_product).order(created_at: :desc)
  end
end
