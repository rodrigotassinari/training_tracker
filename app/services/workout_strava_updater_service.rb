# TODO spec
class WorkoutStravaUpdaterService

  attr_reader :workout, :activity

  def initialize(workout, strava_activity)
    @workout = workout
    @activity = strava_activity
  end

  def update_workout
    return false unless activity_matches_workout?
    set_attributes_from_activity
    workout.save
  end

  private

  def activity_matches_workout?
    valid_types = {
      'cycling' => ['Ride', 'VirtualRide'],
      'running' => ['Run'],
      'swimming' => ['Swim']
    }
    valid_types[workout.kind].include?(activity[:type])
  end

  def activity_matches_workout!
    raise RuntimeError, "activity type '#{activity[:type]}' does not match workout kind '#{workout.kind}'" unless activity_matches_workout?
  end

  # http://strava.github.io/api/v3/activities/
  def set_attributes_from_activity
    workout.name ||= activity[:name] # only if nil
    workout.observations ||= activity[:description] # only if nil
    workout.occurred_on = Time.use_zone(user.try(:time_zone) || 'UTC') { Time.zone.parse(activity[:start_date]).to_date }
    workout.distance = activity[:distance]
    workout.elapsed_time = activity[:elapsed_time]
    workout.moving_time = activity[:moving_time]
    workout.speed_avg = (activity[:average_speed] * 3.6000000).round(8) rescue nil
    workout.speed_max = (activity[:max_speed] * 3.6000000).round(8) rescue nil
    workout.cadence_avg = activity[:average_cadence]
    # workout.cadence_max = activity[:]
    workout.calories = activity[:calories]
    workout.elevation_gain = activity[:total_elevation_gain]
    workout.temperature_avg = activity[:average_temp]
    # workout.temperature_max = activity[:]
    # workout.temperature_min = activity[:]
    workout.watts_avg = activity[:average_watts]
    workout.watts_weighted_avg = activity[:]
    # workout.watts_max = activity[:]
    workout.heart_rate_avg = activity[:average_heartrate]
    workout.heart_rate_max = activity[:max_heartrate]
    # workout.weight_before = activity[:]
    # workout.weight_after = activity[:]
  end

end
