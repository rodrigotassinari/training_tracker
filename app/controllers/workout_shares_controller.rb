class WorkoutSharesController < ApplicationController

  before_action :set_workout
  before_action :check_if_workout_is_async_updating

  # GET /workouts/:workout_id/share/new
  # new_workout_share_path(:workout_id)
  def new
    page_meta[:workout_description] = @workout.short_description
  end

  # POST /workouts/:workout_id/share
  # workout_shares_path(:workout_id)
  def create

  end

  private

  # before_action
  def set_workout
    @workout = WorkoutPresenter.new(
      Workout.find(params[:workout_id])
    )
  end

  # before_action
  def check_if_workout_is_async_updating
    redirect_to(workout_path(@workout), alert: t('.async_updating')) if @workout.async_updating?
    false
  end

end
