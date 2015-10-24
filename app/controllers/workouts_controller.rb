class WorkoutsController < ApplicationController

  # GET /workouts
  # workouts_path
  def index
    @workouts = finder.most_recents
  end

  # GET /workouts/:id
  # workout_path(:id)
  def show
    @workout = finder.find(params[:id])
  end

  # GET /workouts/new
  # new_workout_path
  def new
    @workout = Workout.new_with_defaults(current_user)
  end

  # POST /workouts
  # workouts_path
  def create
    redirect_to new_workout_path
  end

  # GET /workouts/:id/edit
  # edit_workout_path(:id)
  def edit
    @workout = finder.find(params[:id])
  end

  # PUT /workouts/:id
  # PATCH /workouts/:id
  # workout_path(:id)
  def update
    @workout = finder.find(params[:id])
  end

  # DELETE /workouts/:id
  # workout_path(:id)
  def destroy
    @workout = finder.find(params[:id])
  end

  private

  def finder
    @finder ||= WorkoutFinderService.new(current_user)
  end

end
