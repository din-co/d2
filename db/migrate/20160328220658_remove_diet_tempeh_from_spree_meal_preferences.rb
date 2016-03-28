class RemoveDietTempehFromSpreeMealPreferences < ActiveRecord::Migration
  def change
    remove_column :spree_meal_preferences, :diet_tempeh, :boolean
  end
end
