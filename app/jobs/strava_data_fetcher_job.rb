class StravaDataFetcherJob < ActiveJob::Base
  queue_as :default

  # rescue_from(ActiveRecord::RecordNotFound) do |exception|
  #  # do something with the exception
  # end

  # TODO spec
  def perform(workout_id)
    ActiveRecord::Base.connection_pool.with_connection do
      workout = Workout.find(workout_id)
      user = workout.user
      activity = StravaFinderService.new(user).find_activity_by_url(workout.strava_url)
      WorkoutStravaUpdaterService.new(workout, activity).update_workout
    end
  end

end
