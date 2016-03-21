class CreateSpreeMealSubscriptions < ActiveRecord::Migration
  def change
    create_table :spree_meal_subscriptions do |t|
      t.references :user, index: true

      t.integer     :status,            default: 0,    null: false
      t.integer     :delivery_day,      default: 0,    null: false
      t.references  :delivery_window, index: true,     null: false
      t.integer     :meal_count,        default: 2,    null: false
      t.boolean     :notification_sms,  default: true, null: false

      t.timestamps null: false
    end
  end
end
