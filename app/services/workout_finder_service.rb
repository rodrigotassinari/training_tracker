class WorkoutFinderService

  attr_reader :user

  def initialize(user)
    @user = user
  end

  def most_recents(page: 1, per_page: 12)
    user.workouts.order(scheduled_on: :desc).page(page).per(per_page)
  end

  def find(workout_id)
    user.workouts.find(workout_id)
  end

end
