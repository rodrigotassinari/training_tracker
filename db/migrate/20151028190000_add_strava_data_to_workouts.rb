class AddStravaDataToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :strava_data, :jsonb, null: false, default: {}
    add_column :workouts, :garmin_connect_data, :jsonb, null: false, default: {}
  end
end
