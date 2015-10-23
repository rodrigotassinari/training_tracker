class WorkoutFinderService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  # TODO paginate
  def most_recents(page: 1)
    user.workouts.order(scheduled_on: :desc).all
  end

  def find(workout_id)
    user.workouts.find(workout_id)
  end

end
