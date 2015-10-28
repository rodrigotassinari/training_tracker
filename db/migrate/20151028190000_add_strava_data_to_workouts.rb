class AddStravaDataToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :strava_data, :jsonb
  end
end
