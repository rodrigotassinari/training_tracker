class PublicWorkoutsController < ApplicationController

  skip_before_action :require_login
  skip_before_action :require_complete_user

  before_action :set_workout
  around_action :set_time_zone_from_workout, unless: :user_signed_in?

  # GET /workout/:token
  # public_workout_path(:token)
  # TODO spec
  def show
    @public_view = true
    page_meta[:workout_description] = @workout.short_description
    page_meta[:user_description] = @workout.user.name
  end

  private

  # before_action
  def set_workout
    @workout = WorkoutPresenter.new(
      Workout.find_by_public_access_token!(params[:token])
    )
  end

  # around_action
  # TODO spec
  def set_time_zone_from_workout(&block)
    Time.use_zone(@workout.user.time_zone, &block)
  end

end
