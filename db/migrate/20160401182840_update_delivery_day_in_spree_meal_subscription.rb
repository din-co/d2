class UpdateDeliveryDayInSpreeMealSubscription < ActiveRecord::Migration
  def up
    change_column_default(:spree_meal_subscriptions, :delivery_day, 1)
  end
  def down
    change_column_default(:spree_meal_subscriptions, :delivery_day, 0)
  end
end
