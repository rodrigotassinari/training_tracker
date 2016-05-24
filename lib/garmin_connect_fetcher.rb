# both dependencies already used by strava-api-v3
require 'httmultiparty'
require 'multi_json'

class GarminConnectFetcher

  attr_reader :username

  def initialize(username)
    @username = username
  end

  # Fetches a (public) activity by it's ID. It does not have to be from the
  # user, actually.
  #
  # @param activity_id the ID of the activity, as an Integer or String
  #
  # @return a Hash with activity information
  def retrieve_an_activity(activity_id)
    url = "https://connect.garmin.com/proxy/activity-service/activity/#{activity_id.to_s}"
    params = {}

    response = HTTMultiParty.get(url, query: params)
    json = MultiJson.load(response.body.to_s) rescue {}

    json
  end

  # Return an Array of activities, ordered by startTime descending (most recent
  # first). Each activity is a Hash, with keys:
  #
  #   activeLengths, activityId, activityLikeDisplayNames, activityName, activityType, autoCalcCalories, averageBikingCadenceInRevPerMinute, averageHR, averageRunningCadenceInStepsPerMinute, averageSpeed, averageSwimCadenceInStrokesPerMinute, averageSwolf, calories, comments, conversationPk, conversationUuid, courseId, description, distance, duration, elevationGain, elevationLoss, eventType, favorite, hasVideo, likedByUser, maxBikingCadenceInRevPerMinute, maxHR, maxRunningCadenceInStepsPerMinute, maxSpeed, minSwimCadenceInStrokesPerMinute, numberOfActivityComments, numberOfActivityLikes, ownerDisplayName, ownerFullName, ownerId, ownerProfileImageUrlLarge, ownerProfileImageUrlMedium, ownerProfileImageUrlSmall, ownerProfilePk, parent, poolLength, pr, privacy, requestorRelationship, startLatitude, startLongitude, startTimeGMT, startTimeLocal, steps, unitOfPoolLength, userPro, userRoles, videoUrl
  #
  # @param options the pagination and filtering options, optional
  #   @argument per_page the number of activities to return per page, default 20
  #   @argument page the page to return, default 1
  #
  # @return an Array of activities hashes
  def list_athlete_activities(options={})
    limit = options[:per_page] || 20
    page = options[:page] || 1
    start = limit * (page - 1)

    url = "https://connect.garmin.com/proxy/activitylist-service/activities/#{URI.encode(self.username)}"
    params = {
      start: start,
      limit: limit
    }

    response = HTTMultiParty.get(url, query: params)
    json = MultiJson.load(response.body.to_s)

    json['activityList'] rescue []
  end

end
