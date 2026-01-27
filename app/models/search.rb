class Search < ApplicationRecord
  # TO DO: check it later, it was creating bugsss MAX_FILE_SIZE_MB = 10

   # same here, it was taken from the lecture validate :file_size_limit

  belongs_to :user
  has_many :matches, dependent: :destroy
  has_one_attached :uploaded_image

  validate :image_or_link_present

  private

  def image_or_link_present
    unless uploaded_image.attached? || uploaded_link.present?
      errors.add(:base, "Please upload an image or provide a link")
    end
  end
end
