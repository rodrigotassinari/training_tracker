require_dependency 'activity_url_helpers'
class WorkoutPresenter < Burgundy::Item
  include ActivityUrlHelpers

  def self.validators_on(args)
    Workout.validators_on(args)
  end

  [:weight_before, :weight_after, :distance,
    :speed_avg, :speed_max, :cadence_avg, :cadence_max, :calories,
    :temperature_avg, :temperature_max, :temperature_min, :watts_avg,
    :watts_weighted_avg, :watts_max, :heart_rate_avg, :heart_rate_max
    ].each do |attr|
    define_method(attr) do
      helpers.number_with_delimiter(item.send(attr))
    end
  end

  def distance_in_km
    helpers.number_with_precision(item.distance_in_km, precision: 1)
  end

  def elevation_gain
    helpers.number_with_precision(item.elevation_gain, precision: 0)
  end

  def user
    @user ||= UserPresenter.new(item.user)
  end

  def strava_id
    return if item.strava_url.blank?
    parse_strava_activity_id_from_url(item.strava_url)
  end

  def garmin_connect_id
    return if item.garmin_connect_url.blank?
    # TODO
    # parse_garmin_connect_activity_id_from_url(item.garmin_connect_url)
    item.garmin_connect_url
  end

end
