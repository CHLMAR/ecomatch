class Search < ApplicationRecord
  # TO DO: check it later, it was creating bugsss MAX_FILE_SIZE_MB = 10

   # same here, it was taken from the lecture validate :file_size_limit

  belongs_to :user
  has_many :matches, dependent: :destroy
  has_one_attached :uploaded_image

  validate :image_or_link_present
  validates :system_prompt, :clothing_item, :clothing_material,
            :clothing_colour, :clothing_size, :clothing_brand, presence: true

  private

  def image_or_link_present
    if uploaded_image.blank? && uploaded_link.blank?
      errors.add(:base, "Must provide either an image or an image link")
    elsif uploaded_image.present? && uploaded_link.present?
      errors.add(:base, "Must provide either an image or an image link, not both")
    end
  end
end

