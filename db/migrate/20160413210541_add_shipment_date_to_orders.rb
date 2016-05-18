class AddShipmentDateToOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :shipment_date, :datetime
    add_index :spree_orders, :shipment_date
    Spree::Order.complete.where(shipment_date: nil).update_all('shipment_date = completed_at')
  end
end
