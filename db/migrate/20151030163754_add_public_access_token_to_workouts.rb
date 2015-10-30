class AddPublicAccessTokenToWorkouts < ActiveRecord::Migration
  def change
    add_column :workouts, :public_access_token, :string, index: :unique
  end
end
