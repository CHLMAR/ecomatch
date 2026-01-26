class Match < ApplicationRecord
  belongs_to :search
  belongs_to :comparison_product

  validates :similarities, presence: true

  # Access user through search
  delegate :user, to: :search
end
