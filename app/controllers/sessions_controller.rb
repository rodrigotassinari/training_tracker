class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:create]

  # GET /auth/:provider/callback
  def create
    @user = User.find_or_create_from_auth_hash!(auth_hash)
    self.current_user = @user
    redirect_to root_path
    # https://github.com/intridea/omniauth/wiki/Saving-User-Location
    # redirect_to (request.env['omniauth.origin'] || root_path)
  end

  # GET /logout
  # logout_path
  def destroy
    self.current_user = nil
    session.destroy if session.respond_to?(:destroy)
    reset_session
    redirect_to root_path
  end

  protected

  # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  def auth_hash
    request.env['omniauth.auth']
  end

end
