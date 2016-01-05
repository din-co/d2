class CreateSpreeDeliveryWindowZones < ActiveRecord::Migration
  def change
    create_table :spree_delivery_window_zones do |t|
      t.references :delivery_window, index: true, null: false
      t.references :zone, index: true, null: false

      t.timestamps null: false
    end
  end
end
