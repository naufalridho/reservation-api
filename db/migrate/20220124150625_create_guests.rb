class CreateGuests < ActiveRecord::Migration
  def change
    create_table :guests do |t|
      t.string :first_name, null: false
      t.string :last_name, null: false
      t.string :phone, array: true
      t.string :email, null: false, unique: true

      t.timestamps null: false, default: Time.now
    end
  end
end
