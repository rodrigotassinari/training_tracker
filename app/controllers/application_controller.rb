class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :require_login

  private

  # TODO spec
  def logged_in?
    !!current_user
  end
  helper_method :logged_in?

  # TODO spec
  def current_user
    @current_user ||= User.find(session[:user_id]) unless session[:user_id].blank?
  end
  helper_method :current_user

  def current_user=(user)
    reset_session
    session[:user_id] = user.try(:id)
    @current_user = user
  end

  # before_action
  # Requires the current visitor to be logged in, if not redirects to the login
  # page.
  # TODO spec
  def require_login
    # TODO add flash error message
    redirect_to root_path and return unless logged_in?
  end

  # before_action
  # Requires the current visitor to be NOT logged in (to be logged out), if not
  # redirects to the root page.
  # TODO spec
  def require_logout
    # TODO add flash error message
    redirect_to root_path and return if logged_in?
  end

end
