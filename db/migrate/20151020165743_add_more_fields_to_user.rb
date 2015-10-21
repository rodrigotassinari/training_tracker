class AddMoreFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :time_zone, :string, null: false, default: 'UTC'
    add_column :users, :locale, :string, null: false, default: 'en'
  end
end
