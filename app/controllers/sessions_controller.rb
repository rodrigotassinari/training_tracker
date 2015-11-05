class SessionsController < ApplicationController

  skip_before_action :require_login, only: [:create]
  skip_before_action :require_complete_user, only: [:create]

  # GET /auth/:provider/callback
  def create
    user = User.find_or_create_from_auth_hash!(auth_hash)
    self.current_user = user
    if user.just_created?
      redirect_to edit_user_path, notice: t('.thanks_and_finish_sign_up')
    else
      redirect_to workouts_path, notice: t('.success', name: user.name)
      # https://github.com/intridea/omniauth/wiki/Saving-User-Location
      # redirect_to (request.env['omniauth.origin'] || root_path)
    end
  end

  # GET /logout
  # logout_path
  def destroy
    self.current_user = nil
    redirect_to root_path, notice: t('.success')
  end

  protected

  # https://github.com/intridea/omniauth/wiki/Auth-Hash-Schema
  def auth_hash
    request.env['omniauth.auth']
  end

end
