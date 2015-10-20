class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:create]
  skip_before_action :require_complete_user, only: [:create]

  # GET /auth/:provider/callback
  def create
    @user = User.find_or_create_from_auth_hash!(auth_hash)
    self.current_user = @user
    if @user.complete?
      redirect_to root_path
      # https://github.com/intridea/omniauth/wiki/Saving-User-Location
      # redirect_to (request.env['omniauth.origin'] || root_path)
    else
      redirect_to edit_user_path, notice: 'Please finish your profile TODO i18n'
    end
  end

  # GET /logout
  # logout_path
  def destroy
    self.current_user = nil
    session.destroy if session.respond_to?(:destroy)
    reset_session
    redirect_to root_path, notice: 'Logged out successfully TOOD i18n'
  end

  protected

  # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  def auth_hash
    request.env['omniauth.auth']
  end

end
