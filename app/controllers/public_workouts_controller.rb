class PublicWorkoutsController < ApplicationController

  skip_before_action :require_login, only: [:show]
  skip_before_action :require_complete_user, only: [:show]

  # GET /workout/:token
  # public_workout_path(:token)
  # TODO spec
  def show
    @public_view = true
    @workout = WorkoutPresenter.new(
      Workout.find_by_public_access_token!(params[:token])
    )
  end

end
