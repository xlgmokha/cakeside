class PasswordsController < ApplicationController
  before_filter :authenticate_user!

  def index
    @user = current_user
  end

  def update
    ChangePassword.new(self).run(params[:user][:password], params[:user][:password_confirmation])
  end

  def password_changed(user)
    @user = user
    sign_in(@user, bypass: true) unless Rails.env.test?
    flash[:notice] = t('passwords.updated')
    render :index
  end

  def password_changed_failed(user)
    @user = user
    flash[:error] = t(:passwords_do_not_match)
    render :index
  end
end
