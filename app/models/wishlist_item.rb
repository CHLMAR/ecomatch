class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :comparison_product

  validates :user_id, uniqueness: { scope: :comparison_product_id, message: "has already saved this product to wishlist" }
end
