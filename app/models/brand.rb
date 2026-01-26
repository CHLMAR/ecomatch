class Brand < ApplicationRecord
  has_many :comparison_products
  validates :name, :planet_rating, :people_rating, :animals_rating, :overall_rating, :description, presence: true
end
