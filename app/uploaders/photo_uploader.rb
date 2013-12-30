class PhotoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick
  include CarrierWave::MimeTypes
  include ::CarrierWave::Backgrounder::Delay

  process :set_content_type

  version :large do 
    process :resize_to_fit => [570, 630]
    process :watermark
  end

  version :thumb, :from_version => :large do
    process :resize_to_fill => [260, 180]
  end

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def watermark
    return if model.watermark.blank?
    manipulate! do |image|
      gc = Magick::Draw.new
      gc.gravity = Magick::SouthEastGravity
      gc.pointsize = 28
      gc.font_family = "Helvetica"
      gc.font_weight = Magick::BoldWeight
      gc.stroke = 'none'
      mark = Magick::Image.new(image.columns, image.rows)
      gc.annotate(mark, 0, 0, 25, 25, "#{model.watermark} on CakeSide.com")
      mark = mark.shade(true, 310, 30)
      image.composite!(mark, Magick::SouthEastGravity, Magick::HardLightCompositeOp)
    end
  end

  def extension_white_list
    %w(jpg jpeg gif png bmp tif)
  end

  def default_url
    asset_name = "#{version_name}_default.png"
    ActionController::Base.helpers.asset_path(asset_name)
  end
end
