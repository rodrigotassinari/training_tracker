class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  around_action :set_time_zone, if: :user_signed_in?
  before_action :set_locale
  before_action :require_login
  before_action :require_complete_user

  protected

  # TODO spec
  def user_signed_in?
    !!current_user
  end
  helper_method :user_signed_in?

  def current_user
    @current_user ||= User.find_by_id(session[:user_id]) unless session[:user_id].blank?
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
    redirect_to(root_path, alert: t('application_controller.login_required_html')) and return unless user_signed_in?
  end

  # before_action
  # Requires the current user to be complete (see User#complete?) to proceed.
  # TODO spec
  def require_complete_user
    redirect_to(edit_user_path, notice: t('application_controller.complete_profile')) and return if (user_signed_in? && !current_user.complete?)
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

  # around_action
  # TODO spec
  def set_time_zone(&block)
    Time.use_zone(current_user.time_zone, &block)
  end

end
