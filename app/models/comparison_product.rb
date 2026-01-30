class ComparisonProduct < ApplicationRecord
  belongs_to :brand
  has_many :wishlist_items, dependent: :destroy
  validates :brand_id, :clothing_item, :clothing_material, :clothing_colour, :clothing_brand, :external_link, :product_description, presence: true

  scope :by_clothing_item, lambda { |item|
    if item.present?
      where("clothing_item ILIKE ?", "%#{item}%")
    end
  }

  scope :by_clothing_colour, lambda { |colour|
    if colour.present?
      where("clothing_colour ILIKE ?", "%#{colour}%")
    end
  }

  scope :by_clothing_material, lambda { |material|
    if material.present?
      where("clothing_material ILIKE ?", "%#{material}%")
    end
  }

  scope :by_overall_rating, lambda { |rating|
    if rating.present?
      joins(:brand).where(brands: { overall_rating: rating })
    end
  }

  scope :ordered_by_params, lambda { |_rating, _desc|
    joins(:brand).order("brands.overall_rating DESC")
  }
end
