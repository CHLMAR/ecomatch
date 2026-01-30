class WishlistItemsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_comparison_product, only: [:create, :destroy]

  def create
    @wishlist_item = current_user.wishlist_items.build(comparison_product: @comparison_product)

    if @wishlist_item.save
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("wishlist_#{@comparison_product.id}", partial: "shared/wishlist_button", locals: { product: @comparison_product }) }
        format.html { redirect_back(fallback_location: root_path, notice: "Product saved to wishlist!") }
      end
    else
      redirect_back(fallback_location: root_path, alert: @wishlist_item.errors.full_messages.first || "Could not save to wishlist.")
    end
  end

  def destroy
    @wishlist_item = current_user.wishlist_items.find_by(comparison_product_id: @comparison_product.id)

    if @wishlist_item&.destroy
      respond_to do |format|
        format.turbo_stream { render turbo_stream: turbo_stream.replace("wishlist_#{@comparison_product.id}", partial: "shared/wishlist_button", locals: { product: @comparison_product }) }
        format.html { redirect_back(fallback_location: root_path, notice: "Product removed from wishlist!") }
      end
    else
      redirect_back(fallback_location: root_path, alert: "Could not remove from wishlist.")
    end
  end

  private

  def set_comparison_product
    @comparison_product = ComparisonProduct.find(params[:id])
  end
end
