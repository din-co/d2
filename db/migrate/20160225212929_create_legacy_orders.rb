class CreateLegacyOrders < ActiveRecord::Migration
  def change
    create_table :legacy_orders do |t|
      t.string :email, null: false, index: true
      t.string :ref_no, null: false
      t.integer :credits_redeemed, null: false, default: 0
      t.decimal :total_charged, precision: 10, scale: 2, default: 0.0, null: false
      t.string :full_name
      t.string :address
      t.string :apt_suite
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone
      t.string :delivery_window
      t.date :ship_date
      t.date :ship_week
      t.date :delivery_date
      t.string :delivery_method
      t.integer :status_code
      t.timestamps null: false
    end
  end
end
