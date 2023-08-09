class Question < ApplicationRecord

  belongs_to :user
  belongs_to :book

  has_many :favorite_questions, dependent: :destroy
  has_many :replies
  has_many :browsing_histories, dependent: :destroy
  has_many :notifications,              dependent: :destroy

  has_one_attached :image

  validates :title,    presence: true, length: { maximum: 60 }
  validates :content,  presence: true, length: { maximum: 1000 }
  validates :subject,  presence: true
  validates :user_id,    presence: true
  validates :book_id,    presence: true
  validate :image_size_validation
  validate :acceptable_image



  private

  def image_size_validation
    if image.attached? && image.blob.byte_size > 3.megabytes
      errors.add(:image, "は3MB以下のファイルにしてください")
    end
  end

  def acceptable_image
    return unless image.attached?

    unless image.blob.content_type.start_with?('image/jpeg', 'image/png')
      errors.add(:image, 'はjpegまたはpng形式である必要があります')
    end
  end


end
