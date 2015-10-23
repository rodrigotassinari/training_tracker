class CreateWorkouts < ActiveRecord::Migration
  def change
    create_table :workouts do |t|
      t.references :user, null: false, index: true, foreign_key: true
      t.string :kind, null: false, index: true
      t.date :scheduled_on, null: false, index: true
      t.date :occurred_on, index: true
      t.string :name
      t.text :description
      t.text :observations
      t.text :coach_observations
      t.float :distance
      t.integer :elapsed_time
      t.integer :moving_time
      t.float :speed_avg
      t.float :speed_max
      t.integer :cadence_avg
      t.integer :cadence_max
      t.integer :calories
      t.float :elevation_gain
      t.float :temperature_avg
      t.float :temperature_max
      t.float :temperature_min
      t.float :watts_avg
      t.float :watts_weighted_avg
      t.float :watts_max
      t.integer :heart_rate_avg
      t.integer :heart_rate_max
      t.float :weight_before
      t.float :weight_after
      t.timestamps null: false
    end
  end
end
