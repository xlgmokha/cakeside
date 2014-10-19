class ProfilesController < ApplicationController
  def initialize(repository = Spank::IOC.resolve(:users))
    @repository = repository
    super()
  end

  def index
    @profiles = repository.search_with(params).page(params[:page]).per(12)
  end

  def show
    @user = repository.find(params[:id])
    @creations = @user.creations.includes(:photos)
  end

  private

  attr_reader :repository
end
