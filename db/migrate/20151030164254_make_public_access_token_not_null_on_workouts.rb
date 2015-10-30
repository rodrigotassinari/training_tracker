class MakePublicAccessTokenNotNullOnWorkouts < ActiveRecord::Migration
  def change
    change_column :workouts, :public_access_token, :string, index: :unique, null: false
  end
end
