class CreateSpreeMealPreferences < ActiveRecord::Migration
  def change
    create_table :spree_meal_preferences do |t|
      t.references :user, index: true

      t.boolean :diet_beef, default: true, null: false
      t.boolean :diet_lamb, default: true, null: false
      t.boolean :diet_pork, default: true, null: false
      t.boolean :diet_poultry, default: true, null: false
      t.boolean :diet_rabbit, default: true, null: false
      t.boolean :diet_fish, default: true, null: false
      t.boolean :diet_seafood, default: true, null: false
      t.boolean :diet_tofu, default: true, null: false
      t.boolean :diet_tempeh, default: true, null: false

      t.boolean :allergen_none, default: true, null: false
      t.boolean :allergen_eggs, default: false, null: false
      t.boolean :allergen_fish, default: false, null: false
      t.boolean :allergen_milk, default: false, null: false
      t.boolean :allergen_peanuts, default: false, null: false
      t.boolean :allergen_shellfish, default: false, null: false
      t.boolean :allergen_soybeans, default: false, null: false
      t.boolean :allergen_tree_nuts, default: false, null: false
      t.boolean :allergen_wheat_gluten, default: false, null: false

      t.timestamps null: false
    end
  end
end
