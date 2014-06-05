class ProcessPhoto
  def initialize(photos, exif_parser, blob_storage = BlobStorage.new)
    @photos = photos
    @exif_parser = exif_parser
    @blob_storage = blob_storage
  end

  def handles?(event)
    :upload_photo == event
  end

  def handle(message)
    file = File.open(message[:file_path])
    photo = @photos.find(message[:photo_id])
    #photo.image = file
    photo.image_processing = nil
    photo.content_type = message[:content_type]
    photo.original_filename = message[:original_filename]
    photo.latitude, photo.longitude = @exif_parser.parse_geolocation_from(file)
    photo.upload(message[:file_path], @blob_storage)
    photo.save!
  end
end
