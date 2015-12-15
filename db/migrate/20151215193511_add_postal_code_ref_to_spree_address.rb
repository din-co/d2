class AddPostalCodeRefToSpreeAddress < ActiveRecord::Migration
  def change
    add_reference :spree_addresses, :postal_code, index: true
  end
end
