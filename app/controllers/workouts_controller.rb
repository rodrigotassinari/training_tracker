class WorkoutsController < ApplicationController

  before_action :set_workout, except: [:index, :new, :create]

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
  end

  # GET /workouts/new
  # new_workout_path
  def new
    @workout = WorkoutPresenter.new(Workout.new_with_defaults(current_user))
  end

  # POST /workouts
  # workouts_path
  # TODO spec
  def create
    @workout = Workout.new(workout_params)
    @workout.user = current_user
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
  end

  # GET /workouts/:id/do
  # do_workout_path(:id)
  # TODO spec
  def do
    redirect_to(workout_path(@workout), alert: t('.already_done')) if @workout.done?
  end

  # GET /workouts/:id/do_strava
  # do_strava_workout_path(:id)
  # TODO spec
  def do_strava
    redirect_to(workout_path(@workout), alert: t('.already_done')) if @workout.done?
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
      render :edit
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
        :temperature_max, :temperature_min, :watts_avg, :watts_weighted_avg,
        :watts_max, :heart_rate_avg, :heart_rate_max, :strava_url,
        :garmin_connect_url).
      delocalize(weight_before: :number, weight_after: :number,
        distance: :number, distance_in_km: :number, speed_avg: :number,
        speed_max: :number, cadence_avg: :number, cadence_max: :number,
        calories: :number, elevation_gain: :number, temperature_avg: :number,
        temperature_min: :number, temperature_max: :number, watts_avg: :number,
        watts_weighted_avg: :number, watts_max: :number,
        heart_rate_avg: :number, heart_rate_max: :number, scheduled_on: :date,
        occurred_on: :date)
  end

end
