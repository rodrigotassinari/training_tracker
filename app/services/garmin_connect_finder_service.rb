require_dependency 'activity_url_helpers'
require_dependency 'garmin_connect_fetcher'

# TODO spec
class GarminConnectFinderService
  include ActivityUrlHelpers

  attr_reader :user, :client

  def initialize(user)
    @user = user
    raise "User ##{@user.uuid} does not have an associated Garmin Connect username" unless @user.garmin_connect_username?
    @client = GarminConnectFetcher.new(@user.garmin_connect_username)
  end

  # Returns a HashWithIndifferentAccess with activity information.
  # Raises `???` if not found.
  def find_activity(activity_id)
    client.retrieve_an_activity(activity_id).with_indifferent_access
  end

  def find_activity_by_url(activity_url)
    activity_id = parse_garmin_connect_activity_id_from_url(activity_url)
    find_activity(activity_id)
  end

  # Returns an array of activity summary representations sorted newest first.
  #
  def recent_activities(page: 1, per_page: 10)
    list_activities(page: page, per_page: per_page)
  end

  private

  def list_activities(options={})
    client.list_athlete_activities(options).map(&:with_indifferent_access)
  end

end
