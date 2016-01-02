class AddDeliveryWindowIdToSpreeShipments < ActiveRecord::Migration
  def change
    add_reference :spree_shipments, :delivery_window, index: true
  end
end
