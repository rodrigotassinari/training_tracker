# TODO spec
require_dependency 'activity_url_helpers'
class StravaFinderService
  include ActivityUrlHelpers

  attr_reader :user, :identity, :client

  def initialize(user)
    @user = user
    @identity = @user.identities.where(provider: 'strava').first
    raise "User ##{@user.uuid} does not have an associated Strava identity" if @identity.nil?
    raise "User ##{@user.uuid} Strava access_token not found" if @identity.credentials['token'].blank?
    @client = Strava::Api::V3::Client.new(access_token: @identity.credentials['token'])
  end

  # Returns a HashWithIndifferentAccess with activity information.
  # Raises `Strava::Api::V3::ClientError` if not found.
  # http://strava.github.io/api/v3/activities/#get-details
  # https://github.com/jaredholdcroft/strava-api-v3#activity
  def find_activity(activity_id)
    client.retrieve_an_activity(activity_id).with_indifferent_access
  end

  # http://strava.github.io/api/v3/activities/#get-details
  # https://github.com/jaredholdcroft/strava-api-v3#activity
  def find_activity_by_url(activity_url)
    activity_id = parse_strava_activity_id_from_url(activity_url)
    find_activity(activity_id)
  end

  # Returns an array of activity summary representations sorted newest first.
  #
  # http://strava.github.io/api/v3/activities/#get-activities
  # https://github.com/jaredholdcroft/strava-api-v3#activity
  def recent_activities(page: 1, per_page: 10)
    list_activities(page: page, per_page: per_page)
  end

  # Returns an array of activity summary representations, sorted newest first,
  # that happened before the given datetime.
  #
  # http://strava.github.io/api/v3/activities/#get-activities
  # https://github.com/jaredholdcroft/strava-api-v3#activity
  def activities_before(datetime, per_page: 10)
    list_activities(before: datetime.to_i, per_page: per_page)
  end

  # Returns an array of activity summary representations, sorted oldest first,
  # that happened after the given datetime.
  # If no `datetime` is given, will try to use the user's latest done workout
  # datetime (actually the date at midnight).
  #
  # http://strava.github.io/api/v3/activities/#get-activities
  # https://github.com/jaredholdcroft/strava-api-v3#activity
  def activities_after(datetime=nil, per_page: 10)
    datetime ||= user.latest_done_workout.try(:occurred_on).try(:to_time)
    raise ArgumentError, 'datetime not given' if datetime.nil?
    list_activities(after: datetime.to_i, per_page: per_page)
  end

  private

  def list_activities(options={})
    client.list_athlete_activities(options).map(&:with_indifferent_access)
  end

end
