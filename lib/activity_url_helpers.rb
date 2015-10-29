module ActivityUrlHelpers

  private

  # TODO spec
  def is_strava_url?(url)
    uri = URI.parse(url)
    uri.scheme =~ /http/ && uri.host =~ /strava\.com/
  end

  # TODO spec
  def is_strava_activity_url?(activity_url)
    return false unless is_strava_url?(activity_url)
    uri = URI.parse(activity_url)
    uri.path =~ /activities\/[0-9]+/
  end

  # Example valid URLs:
  #   https://www.strava.com/activities/419476182
  #   https://www.strava.com/activities/419476182/analysis
  #   https://www.strava.com/activities/419476182/power-curve
  #   https://www.strava.com/activities/419476182/analysis/609/1724
  #   https://www.strava.com/activities/419476182/analysis/10/1320
  #   https://www.strava.com/activities/419476182/segments/10090717782
  #
  # For any of those, returns "419476182".
  #
  # Raises ArgumentError if URL is not from "strava.com" or does not contain
  # activity information.
  # TODO spec
  def parse_strava_activity_id_from_url(activity_url)
    raise ArgumentError, 'not a Strava URL' unless is_strava_url?(activity_url)
    raise ArgumentError, 'activity information not found' unless is_strava_activity_url?(activity_url)
    uri = URI.parse(activity_url)
    uri.path.split('/')[2]
  end

end
