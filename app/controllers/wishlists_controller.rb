class WishlistsController < ApplicationController
  before_action :authenticate_user!

  def index
    @user = User.find(params[:id])
    @search = Search.where(user: @user).last
    @wishlist_items = @user.wishlist_items.includes(comparison_product: :brand).order(created_at: :desc)
  end
end
