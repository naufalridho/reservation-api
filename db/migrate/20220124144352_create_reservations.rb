class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.string :code, null: false, unique: true
      t.bigint :guest_id
      t.string :guest_phone, array: true
      t.date :start_date, null: false
      t.date :end_date, null: false
      t.integer :num_of_adults, null: false
      t.integer :num_of_children, null: false, default: 0
      t.integer :num_of_infants, null: false, default: 0
      t.string :status, null: false
      t.string :currency, null: false
      t.float :payout_price, null: false
      t.float :security_price, null: false
      t.float :total_price, null: false

      t.timestamps null: false, default: Time.now
    end
  end
end
