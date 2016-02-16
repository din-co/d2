class AddShippingHintToAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :used_for_shipping, :boolean, default: false, null: false
  end
end
