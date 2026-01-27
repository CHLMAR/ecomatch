class Search < ApplicationRecord
  belongs_to :user
  has_many :matches, dependent: :destroy

  validates :system_prompt, :clothing_item, :clothing_material,
            :clothing_colour, :clothing_size, :clothing_brand, presence: true

  validates :image_or_link_present, inclusion: { in: [true] }

  private

   def image_or_link_present
    if image.blank? && image_link.blank?
      return false
    end
   end
end
