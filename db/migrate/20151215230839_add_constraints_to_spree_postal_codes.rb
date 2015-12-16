class AddConstraintsToSpreePostalCodes < ActiveRecord::Migration
  def change
    change_column :spree_postal_codes, :country_id, :integer, null: false
    add_index :spree_postal_codes, [:country_id, :value], unique: true
  end
end
