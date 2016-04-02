FactoryGirl.define do
  factory :meal_subscription, class: Spree::MealSubscription do
    user
    meal_count 2
    delivery_window { Spree::DeliveryWindow.first }
  end
end
