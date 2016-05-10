require 'rails_helper'

RSpec.describe SubscriptionOrderManager, subscription_data: true do
  let(:available_meals) do
    {
      breakfast_sandwich => 3,
      sauteed_fish => 3,
      tofu_fried_rice => 3,
      braised_veg => 3,
    }
  end

  let(:sub_manager) { described_class.new(available_meals) }
  let(:subscriptions) do
    [
      FactoryGirl.create(:meal_subscription, delivery_day: :monday),
      FactoryGirl.create(:meal_subscription, delivery_day: :monday),
      FactoryGirl.create(:meal_subscription, delivery_day: :monday, meal_count: 3),
    ]
  end

  it "creates all orders with correct line items and totals" do
    orders = sub_manager.create_orders!(subscriptions)
    expect(orders.size).to eql subscriptions.size
    by_user = orders.index_by(&:user_id)
    subscriptions.each do |subscription|
      order = by_user[subscription.user_id]
      expect(order).not_to be_nil
      expect(order.quantity).to eql(subscription.meal_count)
      expect(order.state).to eql('confirm'), lambda { order.errors.full_messages }
    end
  end

  pending "handles missing meals when meal preferences cannot be satisfied"
end
