# TODO spec
require_dependency 'activity_url_helpers'
class GarminConnectFinderService
  include ActivityUrlHelpers

  attr_reader :user, :client

  def initialize(user)
    @user = user
    raise "User ##{@user.uuid} does not have an associated Garmin Connect username" unless @user.garmin_connect_username?
    @client = nil # TODO
  end

  # Returns a HashWithIndifferentAccess with activity information.
  # Raises `???` if not found.
  def find_activity(activity_id)
    # TODO
    # client.retrieve_an_activity(activity_id).with_indifferent_access
    {}.with_indifferent_access
  end

  def find_activity_by_url(activity_url)
    activity_id = parse_garmin_connect_activity_id_from_url(activity_url)
    find_activity(activity_id)
  end

  # Returns an array of activity summary representations sorted newest first.
  #
  def recent_activities(page: 1, per_page: 10)
    # TODO
    list_activities(page: page, per_page: per_page)
  end

  # Returns an array of activity summary representations, sorted newest first,
  # that happened before the given datetime.
  #
  def activities_before(datetime, per_page: 10)
    # TODO
    list_activities(before: datetime.to_i, per_page: per_page)
  end

  # Returns an array of activity summary representations, sorted oldest first,
  # that happened after the given datetime.
  # If no `datetime` is given, will try to use the user's latest done workout
  # datetime (actually the date at midnight).
  #
  def activities_after(datetime=nil, per_page: 10)
    # TODO
    datetime ||= user.latest_done_workout.try(:occurred_on).try(:to_time)
    raise ArgumentError, 'datetime not given' if datetime.nil?
    list_activities(after: datetime.to_i, per_page: per_page)
  end

  private

  def list_activities(options={})
    # TODO
    []
    # client.list_athlete_activities(options).map(&:with_indifferent_access)
  end

end
