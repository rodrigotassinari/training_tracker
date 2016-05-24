class AddGarminUsernameToUsers < ActiveRecord::Migration
  def change
    add_column :users, :garmin_connect_username, :string
  end
end
