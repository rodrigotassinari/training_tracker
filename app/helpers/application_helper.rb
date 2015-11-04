module ApplicationHelper

  def omniauth_login_path(provider)
    "/auth/#{provider}"
  end

  def strava_login_path
    omniauth_login_path(:strava)
  end

  def locale_mask(mask)
    "#{I18n.locale}_#{mask}"
  end

end
