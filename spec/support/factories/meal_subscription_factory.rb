FactoryGirl.define do
  factory :meal_subscription, class: Spree::MealSubscription do
    user
    meal_count 2
    delivery_window { Spree::DeliveryWindow.first }

    after(:create) do |subscription|
      user = subscription.user
      user.meal_preference || user.create_meal_preference!
      user.default_address || user.default_address = create(:ship_address)
      user.default_credit_card || user.credit_cards.create!(attributes_for(:credit_card, default: true))
    end
  end
end
