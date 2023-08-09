module ImageCompressionConcern
  extend ActiveSupport::Concern

  def compress_image(uploaded_file)
    ImageProcessing::MiniMagick
      .source(uploaded_file)
      .saver(quality: 70)
      .call
  end
end
