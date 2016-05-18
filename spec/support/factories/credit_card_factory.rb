FactoryGirl.modify do
  factory :credit_card do
    payment_method { Spree.default_payment_method }
    cc_type "visa"
    last_digits "4242"
    sequence(:gateway_customer_profile_id, 1234) { |n| "cus_rando#{n}" }
    sequence(:gateway_payment_profile_id, 1234) { |n| "card_rando#{n}" }
    number nil
  end
end
