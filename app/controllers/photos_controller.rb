class PhotosController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_creation
  before_filter :find_or_build_photo

  def create
    respond_to do |format|
      if @photo.save
        format.html { redirect_to(@creation, :notice => 'A new photo was added to the album.') }
      else
        flash[:error] = "could not upload photo"
      end
    end
  end

  def destroy
    respond_to do |format|
      if @photo.destroy
        format.html { redirect_to(@creation, :notice => 'A new photo was added to the album.') }
      else
        flash[:error] = "photo could not be deleted"
      end
    end
  end

  private
  def find_creation
    @creation = current_user.creations.find(params[:creation_id])
    raise ActiveRecord::RecordNotFound unless @creation
  end

  def find_or_build_photo
    @photo = params[:id] ? @creation.photos.find(params[:id]) : @creation.photos.build(params[:photo])
  end

end