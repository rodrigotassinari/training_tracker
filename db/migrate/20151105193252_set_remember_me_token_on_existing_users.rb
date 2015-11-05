class SetRememberMeTokenOnExistingUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      begin
        user.update_column(:remember_me_token, SecureRandom.urlsafe_base64(24))
      rescue
        user.update_column(:remember_me_token, SecureRandom.urlsafe_base64(24))
      end
    end
  end
end
