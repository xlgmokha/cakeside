class CreationsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @creations = FindAllCreationsQuery.new.fetch(params)
    MixPanel.track "Viewed Home Page", {}, @request_env
  end

  def show
    @creation = Creation.find(params[:id])
    @primary_photo = @creation.primary_image
  end

  def new
    @creation = Creation.new
    @user = current_user
  end

  def edit
    @creation = current_user.creations.find(params[:id])
  end

  def create
    @creation = current_user.creations.create(params[:creation])
    @creation.category_ids = params[:creation][:category_ids] ||= []
    current_user.tag(@creation, :with => params[:creation_tags], :on => :tags)

    if @creation.save
      redirect_to new_creation_photo_url(@creation)
    else
      @user = current_user
      flash[:error] = @creation.errors.full_messages
      render :action => "new" 
    end
  end

  def update
    @creation = current_user.creations.find(params[:id])
    @creation.category_ids = params[:creation][:category_ids] ||= []
    current_user.tag(@creation, :with => params[:creation_tags], :on => :tags)

    if @creation.update_attributes(params[:creation])
      redirect_to new_creation_photo_url(@creation)
    else
      flash[:error] = @creation.errors.full_messages
      render :action => "edit" 
    end
  end

  def destroy
    current_user.creations.find(params[:id]).destroy
    redirect_to(creations_url) 
  end
end
