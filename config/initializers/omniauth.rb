# https://github.com/thogg4/omniauth-strava
# https://www.strava.com/settings/api
Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :developer unless (Rails.env.production? || Rails.env.staging?)
  provider :strava, ENV['STRAVA_CLIENT_ID'], ENV['STRAVA_API_KEY'], scope: 'view_private'
end

OmniAuth.config.logger = Rails.logger

# https://github.com/intridea/omniauth/wiki/FAQ#omniauthfailureendpoint-does-not-redirect-in-development-mode
OmniAuth.config.on_failure = Proc.new { |env|
  OmniAuth::FailureEndpoint.new(env).redirect_to_failure
}
