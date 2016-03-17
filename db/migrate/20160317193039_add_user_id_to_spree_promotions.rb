class AddUserIdToSpreePromotions < ActiveRecord::Migration
  def change
    add_column :spree_promotions, :user_id, :integer
    add_index :spree_promotions, [:user_id, :promotion_category_id], unique: true
    add_index :spree_promotions, :path, unique: true
  end
end
