class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :set_locale
  before_action :set_time_zone
  before_action :require_login
  before_action :require_complete_user

  private

  # TODO spec
  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?

  # TODO spec
  def current_user
    @current_user ||= User.find(session[:user_id]) unless session[:user_id].blank?
  end
  helper_method :current_user

  # TODO spec
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
    redirect_to root_path and return unless user_signed_in?
  end

  # before_action
  # Requires the current visitor to be NOT logged in (to be logged out), if not
  # redirects to the root page.
  # TODO spec
  def require_logout
    # TODO add flash error message
    redirect_to root_path and return if user_signed_in?
  end

  # before_action
  # Requires the current user to be complete (see User#complete?) to proceed.
  # TODO spec
  def require_complete_user
    # TODO add flash notice message
    redirect_to edit_user_path and return unless current_user.complete?
  end

  # before_action
  # TODO spec
  def set_locale
    I18n.locale = if user_signed_in? &&
      current_user.locale.present?
      current_user.locale
    else
      # see https://github.com/iain/http_accept_language#example
      http_accept_language.compatible_language_from(I18n.available_locales) || I18n.default_locale
    end
  end

  # before_action
  # TODO around_filter ? http://api.rubyonrails.org/classes/Time.html#method-c-zone-3D
  # TODO spec
  def set_time_zone
    Time.zone = if user_signed_in? &&
      current_user.time_zone.present?
      current_user.time_zone
    else
      # TODO get time_zone from browser or use default
      'UTC'
    end
  end

end
