class SpreeProductPropertiesToText < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :spree_product_properties do |t|
        dir.up   { t.change(:value, :text) }
        dir.down { t.change(:value, :string) }
      end
    end
  end
end
