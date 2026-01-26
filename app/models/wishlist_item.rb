class WishlistItem < ApplicationRecord
  belongs_to :user
  belongs_to :match
  belongs_to :comparison_product
end
