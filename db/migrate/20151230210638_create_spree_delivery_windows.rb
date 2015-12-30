class CreateSpreeDeliveryWindows < ActiveRecord::Migration
  def change
    create_table :spree_delivery_windows do |t|
      t.integer :start_hour, null: false
      t.integer :duration, null: false
      t.integer :lead_time_duration, null: false

      t.timestamps null: false
    end
  end
end
