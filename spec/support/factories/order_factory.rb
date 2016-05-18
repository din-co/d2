FactoryGirl.modify do
  factory :order_ready_to_ship do
    after(:create) do |order|
      order.refresh_shipment_rates
      now = Time.current
      order.update_columns(completed_at: now, shipment_date: now)
    end
  end
end

FactoryGirl.define do
  factory :subscription_order, parent: :order_ready_to_ship do
    after(:create) do |order|
      order.update_columns(completed_at: 5.days.ago, shipment_date: Time.current)
    end
  end
end
