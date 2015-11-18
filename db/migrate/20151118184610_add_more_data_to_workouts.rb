class AddMoreDataToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :energy_output, :float
    rename_column :workouts, :watts_avg, :power_avg
    rename_column :workouts, :watts_weighted_avg, :power_weighted_avg
    rename_column :workouts, :watts_max, :power_max
  end
end
