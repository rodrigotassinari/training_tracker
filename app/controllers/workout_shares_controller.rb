class WorkoutSharesController < ApplicationController
  include WorkoutsChecker

  before_action :set_workout
  before_action :check_if_workout_is_async_updating

  # GET /workouts/:workout_id/shares/new
  # new_workout_share_path(:workout_id)
  # TODO spec
  def new
    page_meta[:workout_description] = @workout.short_description
    @workout_share = WorkoutShare.new(workout: @workout)
  end

  # POST /workouts/:workout_id/shares
  # workout_shares_path(:workout_id)
  # TODO spec
  def create
    @workout_share = WorkoutShare.new(
      workout_share_params.merge(workout: @workout)
    )
    if @workout_share.send_emails
      redirect_to(workout_path(@workout), notice: t('.success'))
    else
      render :new
    end
  end

  private

  def workout_share_params
    params.require(:workout_share).
      permit(:emails)
  end

  # before_action
  def set_workout
    @workout = WorkoutPresenter.new(
      Workout.find(params[:workout_id])
    )
  end

end
