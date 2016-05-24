FactoryGirl.modify do
  factory :order_ready_to_ship do
    shipment_date 1.day.from_now.midnight
    after(:create) do |order|
      order.refresh_shipment_rates
      order.update_columns(completed_at: Time.current)
    end
  end
end

FactoryGirl.define do
  factory :subscription_order, parent: :order_ready_to_ship do
    shipment_date Time.current.midnight
    after(:create) do |order|
      order.update_columns(completed_at: 5.days.ago)
    end
  end
end
