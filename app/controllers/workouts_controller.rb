class WorkoutsController < ApplicationController
  include WorkoutsChecker

  before_action :set_workout, except: [:index, :new, :create]
  before_action :check_if_workout_is_async_updating, only: [:edit, :update, :do_strava, :do, :undo]

  # GET /workouts
  # workouts_path
  def index
    @workouts = WorkoutPresenter.wrap(
      finder.most_recents(page: params[:page])
    )
  end

  # GET /workouts/:id
  # workout_path(:id)
  def show
    page_meta[:workout_description] = @workout.short_description
  end

  # GET /workouts/new
  # new_workout_path
  def new
    @workout = WorkoutPresenter.new(
      Workout.new_with_defaults(
        current_user!
      )
    )
  end

  # POST /workouts
  # workouts_path
  # TODO spec
  def create
    @workout = Workout.new(workout_params)
    @workout.user = current_user!
    if @workout.save
      redirect_to workout_path(@workout),
        notice: t('.success')
    else
      render :new
    end
  end

  # GET /workouts/:id/edit
  # edit_workout_path(:id)
  # TODO spec
  def edit
    page_meta[:workout_description] = @workout.short_description
  end

  # GET /workouts/:id/do
  # do_workout_path(:id)
  # TODO spec
  def do
    redirect_to(workout_path(@workout), alert: t('.already_done')) if @workout.done?
    redirect_to(workout_path(@workout), alert: t('.already_skipped')) if @workout.skipped?
    @workout.weight_before = current_user.latest_weight_before
  end

  # GET /workouts/:id/do_strava
  # do_strava_workout_path(:id)
  # TODO spec
  def do_strava
    redirect_to(workout_path(@workout), alert: t('.already_done')) if @workout.done?
    redirect_to(workout_path(@workout), alert: t('.already_skipped')) if @workout.skipped?
    @workout.weight_before = current_user.latest_weight_before
  end

  # GET /workouts/:id/do_not
  # do_not_workout_path(:id)
  # TODO spec
  def do_not
    redirect_to(workout_path(@workout), alert: t('.already_done')) if @workout.done?
    redirect_to(workout_path(@workout), alert: t('.already_skipped')) if @workout.skipped?
    @workout.skipped = true
    @workout.weight_before = current_user.latest_weight_before
  end

  # PUT /workouts/:id
  # PATCH /workouts/:id
  # workout_path(:id)
  # TODO spec
  def update
    if @workout.update(workout_params)
      @workout.fetch_strava_data! if @workout.needs_strava_data?
      redirect_to workout_path(@workout),
        notice: t('.success')
    else
      page_meta[:workout_description] = @workout.short_description
      render :edit
    end
  end

  # GET /workouts/:id/strava_activities (ajax only)
  # strava_activities_workout_path(:id)
  # TODO spec
  def strava_activities
    @search_date = current_user.latest_done_workout.try(:occurred_on) || @workout.scheduled_on
    @activities = StravaFinderService.new(current_user).activities_after(@search_date.to_time, per_page: 10)
    respond_to do |format|
      format.js
    end
  end

  # DELETE /workouts/:id/undo
  # undo_workout_path(:id)
  # TODO spec
  def undo
    @workout.undo
    redirect_to workout_path(@workout),
      notice: t('.success')
  end

  # DELETE /workouts/:id
  # workout_path(:id)
  # TODO spec
  def destroy
    @workout.destroy
    redirect_to workouts_path,
      notice: t('.success')
  end

  private

  def finder
    @finder ||= WorkoutFinderService.new(current_user)
  end

  def set_workout
    @workout = WorkoutPresenter.new(finder.find(params[:id]))
  end

  def workout_params
    params.require(:workout).
      permit(:kind, :scheduled_on, :occurred_on, :name, :description,
        :observations, :coach_observations, :weight_before, :weight_after,
        :distance, :distance_in_km, :elapsed_time_in_hours,
        :moving_time_in_hours, :speed_avg, :speed_max, :cadence_avg,
        :cadence_max, :calories, :elevation_gain, :temperature_avg,
        :temperature_max, :temperature_min, :power_avg, :power_weighted_avg,
        :power_max, :energy_output, :heart_rate_avg, :heart_rate_max,
        :strava_url, :garmin_connect_url, :skipped).
      delocalize(weight_before: :number, weight_after: :number,
        distance: :number, distance_in_km: :number, speed_avg: :number,
        speed_max: :number, cadence_avg: :number, cadence_max: :number,
        calories: :number, elevation_gain: :number, temperature_avg: :number,
        temperature_min: :number, temperature_max: :number, power_avg: :number,
        power_weighted_avg: :number, power_max: :number, energy_output: :number,
        heart_rate_avg: :number, heart_rate_max: :number, scheduled_on: :date,
        occurred_on: :date)
  end

end
