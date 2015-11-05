class AddRememberMeTokenToUsers < ActiveRecord::Migration
  def change
    add_column :users, :remember_me_token, :string, index: :unique
  end
end
