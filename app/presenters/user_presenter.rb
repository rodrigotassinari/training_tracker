class UserPresenter < Burgundy::Item

  def self.validators_on(args)
    User.validators_on(args)
  end

  # TODO spec
  def strava_identity
    @strava_identity ||= item.identities.where(provider: 'strava').first!
  end

  # TODO spec
  def location
    # strava_identity.info['location']
    [strava_identity.extra['raw_info']['city'],
    strava_identity.extra['raw_info']['state'],
    strava_identity.extra['raw_info']['country']].join(', ')
  end

  # TODO spec
  def strava_profile_url
    "https://www.strava.com/athletes/#{strava_identity.extra['raw_info']['id']}"
  end

  # TODO spec
  def strava_photo_url(format=:large)
    if format == :large
      strava_identity.extra['raw_info']['profile'] # large, 124x124
    else
      strava_identity.extra['raw_info']['profile_medium'] # medium, 60x60
    end
  end

end
