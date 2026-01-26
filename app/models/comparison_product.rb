class ComparisonProduct < ApplicationRecord
  belongs_to :brand
  validates :brand_id, :clothing_item, :clothing_material, :clothing_colour, :clothing_brand, :external_link, :product_description, presence: true
end
