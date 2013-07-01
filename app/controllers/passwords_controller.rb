class PasswordsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end

  def update
    user = current_user
    if user.change_password(params[:user][:password], params[:user][:password_confirmation])
      render :index
    else
      flash[:error] = t(:passwords_do_not_match)
      render :index
    end
  end
end
