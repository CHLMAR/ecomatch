class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :comparison_product

  validates :user_id, uniqueness: { scope: :match_id, message: "has already saved this match to wishlist" }
end
