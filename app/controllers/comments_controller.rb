class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def new
    @comment = Comment.new
  end

  def create
    creation = Creation.find(params[:creation_id])
    comment = Comment.build_from(creation, current_user, params[:comment][:body])
    if comment.save
      redirect_to creation_path(creation)
    else
      flash[:error] = "Ooops... we couldn't save your comment at this time."
      render 'new'
    end
  end
end