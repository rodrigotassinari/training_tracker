class WorkoutStravaUpdaterService
  include ActiveModel::Validations

  KINDS_TO_TYPES = {
    'cycling' => ['Ride', 'VirtualRide'],
    'running' => ['Run'],
    'swimming' => ['Swim']
  }

  validate :activity_matches_workout

  attr_reader :workout, :activity

  def initialize(workout, strava_activity)
    @workout = workout
    @activity = strava_activity
  end

  def update_workout
    if valid? # TODO raise error? since we are doing this async now
      set_attributes_from_activity
      workout.save!
    end
  end

  private

  # validation
  def activity_matches_workout
    unless KINDS_TO_TYPES[workout.kind].include?(activity[:type])
      errors.add(:activity, "activity type '#{activity[:type]}' does not match workout kind '#{workout.kind}'")
    end
  end

  # http://strava.github.io/api/v3/activities/
  def set_attributes_from_activity
    workout.name ||= activity[:name] # only if nil
    workout.observations ||= activity[:description] # only if nil
    workout.occurred_on = Time.use_zone(workout.user.try(:time_zone) || 'UTC') { Time.zone.parse(activity[:start_date]).to_date }
    workout.distance = activity[:distance]
    workout.elapsed_time = activity[:elapsed_time]
    workout.moving_time = activity[:moving_time]
    workout.speed_avg = (activity[:average_speed] * 3.6000000).round(8) rescue nil
    workout.speed_max = (activity[:max_speed] * 3.6000000).round(8) rescue nil
    workout.cadence_avg = activity[:average_cadence].to_i unless activity[:average_cadence].nil?
    # workout.cadence_max = activity[:]
    workout.calories = activity[:calories].to_i unless activity[:calories].nil?
    workout.elevation_gain = activity[:total_elevation_gain]
    workout.temperature_avg = activity[:average_temp]
    # workout.temperature_max = activity[:]
    # workout.temperature_min = activity[:]
    workout.power_avg = activity[:average_watts]
    # workout.power_weighted_avg = activity[:]
    # workout.power_max = activity[:]
    workout.energy_output = activity[:kilojoules]
    workout.heart_rate_avg = activity[:average_heartrate].to_i unless activity[:average_heartrate].nil?
    workout.heart_rate_max = activity[:max_heartrate].to_i unless activity[:max_heartrate].nil?
    # workout.weight_before = activity[:]
    # workout.weight_after = activity[:]
    workout.strava_data = activity
  end

end
