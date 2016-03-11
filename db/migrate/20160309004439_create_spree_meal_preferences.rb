class CreateSpreeMealPreferences < ActiveRecord::Migration
  def change
    create_table :spree_meal_preferences do |t|
      t.boolean :diet_beef
      t.boolean :diet_lamb
      t.boolean :diet_pork
      t.boolean :diet_poultry
      t.boolean :diet_rabbit
      t.boolean :diet_fish
      t.boolean :diet_seafood
      t.boolean :diet_tofu
      t.boolean :diet_tempeh

      t.boolean :allergen_none
      t.boolean :allergen_eggs
      t.boolean :allergen_fish
      t.boolean :allergen_milk
      t.boolean :allergen_peanuts
      t.boolean :allergen_shellfish
      t.boolean :allergen_soybeans
      t.boolean :allergen_tree_nuts
      t.boolean :allergen_wheat_gluten
      t.references :user

      t.timestamps null: false
    end
  end
end
