class SpreeProductPropertiesToText < ActiveRecord::Migration
  def up
    change_table :spree_product_properties do |t|
      t.change(:value, :text)
    end
  end

  def down
    change_table :spree_product_properties do |t|
      t.change(:value, :string)
    end
  end
end
