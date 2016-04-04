class AddStartDateToSpreeMealSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_meal_subscriptions, :start_date, :datetime
  end
end
