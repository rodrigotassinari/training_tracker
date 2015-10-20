class CreateUsers < ActiveRecord::Migration
  def change
    enable_extension 'uuid-ossp'

    create_table :users do |t|
      t.string :name, null: false
      t.string :email

      t.timestamps null: false
    end
  end
end
