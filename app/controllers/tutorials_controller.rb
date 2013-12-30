class TutorialsController < ApplicationController
  before_filter :authenticate_user!, :except => [:show, :index]

  def index
    @tutorials = Tutorial.includes(:tags).page(params[:page]).per(15)
    expires_in(10.minutes)
    fresh_when(Tutorial.maximum(:updated_at)) if Tutorial.any?
  end

  def show
    @tutorial = Tutorial.find(params[:id])
    expires_in(24.hours)
    fresh_when(@tutorial)
  end

  def new
    @tutorial = Tutorial.new
    @user = current_user
  end

  def edit
    @tutorial = current_user.tutorials.find(params[:id])
  end

  def create
    @tutorial = current_user.tutorials.create(tutorial_params)
    current_user.tag(@tutorial, :with => params[:tutorial_tags], :on => :tags)
    if @tutorial.save
      redirect_to tutorials_path, :notice => t(:tutorial_saved)
    else
      flash[:error] = @tutorial.errors.full_messages
      render :new
    end
  end

  def update
    @tutorial = current_user.tutorials.find(params[:id])
    current_user.tag(@tutorial, :with => params[:tutorial_tags], :on => :tags)
    if @tutorial.update_attributes(tutorial_params)
      redirect_to @tutorial
    else
      render :edit
    end
  end

  def destroy
    @tutorial = current_user.tutorials.find(params[:id])
    @tutorial.destroy

    respond_to do |format|
      format.html { redirect_to(tutorials_url) }
    end
  end

  def tutorial_params
    params.require(:tutorial).permit(:url, :heading)
  end
end
