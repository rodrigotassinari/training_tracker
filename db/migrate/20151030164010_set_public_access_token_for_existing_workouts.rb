class SetPublicAccessTokenForExistingWorkouts < ActiveRecord::Migration
  def change
    Workout.find_each do |workout|
      begin
        workout.update_column(:public_access_token, SecureRandom.urlsafe_base64(24))
      rescue
        workout.update_column(:public_access_token, SecureRandom.urlsafe_base64(24))
      end
    end
  end
end
