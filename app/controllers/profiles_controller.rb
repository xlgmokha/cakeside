class ProfilesController < ApplicationController
  before_filter :authenticate_user!, :except => [:show]

  def index
    @profiles = User.page(params[:page]).per(16)
  end

  def show
    @profile = User.find(params[:id])
    @creations = @profile.creations.page(params[:page]).per(16)
  end

  def mine
    @creations = current_user.creations.page(params[:page]).per(16)
  end

  def favorites
    @favorites = current_user.favorites
    @creations = @favorites.map {|f| f.creation }
  end
end
