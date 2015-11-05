class MakeRememberMeTokenNotNullOnUsers < ActiveRecord::Migration
  def change
    change_column :users, :remember_me_token, :string, index: :unique, null: false
  end
end
