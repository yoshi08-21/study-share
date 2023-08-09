module CustomValidation
  extend ActiveSupport::Concern

  included do
    validate :image_size_validation
    validate :acceptable_image
  end

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
