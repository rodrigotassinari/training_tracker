class WorkoutStravaActivity
  include ActiveModel::Validations

  attr_reader :workout, :strava_activity
  attr_accessor :strava_url, :observations, :coach_observations, :weight_before, :weight_after

  validates :strava_url, presence: true
  validates :weight_before, numericality: {
    greater_than_or_equal_to: 0.0, allow_blank: true}
  validates :weight_after, numericality: {
    greater_than_or_equal_to: 0.0, allow_blank: true}

  validate :strava_url_format

  def initialize(workout, attributes={})
    @workout = workout
    @strava_activity = nil
    [:strava_url, :observations, :coach_observations, :weight_before, :weight_after].each do |attr|
      instance_variable_set("@#{attr}", attributes[attr])
    end
  end

  def to_key
    nil
  end

  def save
    valid? &&
      set_workout_attributes &&
      find_strava_activity &&
      WorkoutStravaUpdaterService.new(workout, strava_activity).update_workout
  end

  private

  def set_workout_attributes
    workout.observations = observations
    workout.coach_observations = coach_observations
    workout.weight_before = weight_before unless weight_before.blank?
    workout.weight_after = weight_after unless weight_after.blank?

    Rails.logger.debug('>>> set_workout_attributes OK')
    true
  end

  def strava_url_format
    # TODO improve this, make sure there's an activity ID, etc
    if !strava_url.blank? && strava_url !~ /strava\.com/
      errors.add(:strava_url, :invalid)
    end
  end

  def find_strava_activity
    @strava_activity = StravaFinderService.new(workout.user).
      find_activity_by_url(strava_url)

    Rails.logger.debug('>>> find_strava_activity OK')
    Rails.logger.debug(">>> find_strava_activity: #{@strava_activity[:id]}")
    true
  end

end
