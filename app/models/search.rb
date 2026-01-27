class Search < ApplicationRecord
  belongs_to :user
  has_many :matches, dependent: :destroy

  validates :system_prompt, :clothing_item, :clothing_material,
            :clothing_colour, :clothing_size, :clothing_brand, presence: true

  validate :image_or_link_present

  private

  def image_or_link_present
    if uploaded_image.blank? && uploaded_link.blank?
      errors.add(:base, "Must provide either an image or an image link")
    elsif uploaded_image.present? && uploaded_link.present?
      errors.add(:base, "Must provide either an image or an image link, not both")
    end
  end
end

