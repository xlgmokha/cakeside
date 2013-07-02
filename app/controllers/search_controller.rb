class SearchController < ApplicationController
  def index
    @search = params[:q]
    if @search.blank?
      redirect_to(root_url)
    else
      @creations = Creation.includes(:user).search(@search).page(params[:page]).per(100)
      @members = User.includes(:avatar).where("upper(name) like upper(?)", "%#{@search}%")
      @tutorials = Tutorial.where("upper(heading) like upper(?) OR upper(description) like upper(?)", "%#{@search}%", "%#{@search}%")
    end
  end
end
