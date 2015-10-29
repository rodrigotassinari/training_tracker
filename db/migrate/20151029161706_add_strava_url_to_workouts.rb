class AddStravaUrlToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :strava_url, :string
    add_column :workouts, :garmin_connect_url, :string
  end
end
