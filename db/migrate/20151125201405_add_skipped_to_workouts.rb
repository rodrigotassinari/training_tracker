class AddSkippedToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :skipped, :boolean, default: false, null: false
  end
end
