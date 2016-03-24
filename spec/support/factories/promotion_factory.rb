require 'spree/testing_support/factories/promotion_factory'
FactoryGirl.define do
  factory :personalized_referral_promotion, parent: :promotion_with_order_adjustment do
    transient do
      from "your friend"
    end

    promotion_category { Spree::PromotionCategory.find_or_create_by!(name: "Personal Referral") }
    name { "courtesy of #{from}" }
    description { "#{Spree::Money.new(weighted_order_adjustment_amount)} off your first order" }
    path { [user_id, from.parameterize, weighted_order_adjustment_amount.to_s].compact.join('-') }
    after(:create) do |promotion, evaluator|
      promotion.rules << Spree::Promotion::Rules::FirstOrder.create!(promotion: promotion)
      promotion.save!
    end
  end
end
