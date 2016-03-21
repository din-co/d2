class AddDeliveryInstructionsToAddress < ActiveRecord::Migration
  def change
    add_column :spree_addresses, :delivery_instructions, :text
  end
end
