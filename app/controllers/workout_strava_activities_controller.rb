# TODO spec
class WorkoutStravaActivitiesController < ApplicationController

  before_action :set_workout

  # GET /workouts/:workout_id/strava/new
  # new_workout_strava_path(:workout_id)
  def new
    @activity = StravaActivityPresenter.new(
      StravaActivity.new(@workout)
    )
  end

  # POST /workouts/:workout_id/strava
  # workout_strava_path(:workout_id)
  def create
    @activity = StravaActivityPresenter.new(
      StravaActivity.new(@workout, strava_activity_params)
    )
    if @activity.save
      redirect_to workout_path(@workout),
        notice: t('.success')
    else
      render :new
    end
  end

  # GET /workouts/:workout_id/strava/edit
  # edit_workout_strava_path(:workout_id)
  def edit
  end

  # PUT /workouts/:workout_id/strava
  # PATCH /workouts/:workout_id/strava
  # workout_strava_path(:workout_id)
  def update
  end

  # DELETE /workouts/:workout_id/strava
  # workout_strava_path(:workout_id)
  def destroy
  end

  # GET /workouts/:workout_id/strava
  # workout_strava_path(:workout_id)
  def show
  end

  private

  def set_workout
    @workout = WorkoutPresenter.new(
      WorkoutFinderService.new(current_user).find(params[:workout_id])
    )
  end

  def strava_activity_params
    params.require(:strava_activity).
      permit(:strava_url, :observations, :coach_observations, :weight_before, :weight_after).
      delocalize(weight_before: :number, weight_after: :number)
  end

end
