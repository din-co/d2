class AddNotificationEmailToSpreeMealSubscriptions < ActiveRecord::Migration
  def change
    add_column :spree_meal_subscriptions, :notification_email, :boolean, null: false, default: true
  end
end
