FactoryGirl.define do
  factory :personalized_referral_promotion, parent: :promotion_with_order_adjustment do
    promotion_category { Spree::PromotionCategory.find_or_create_by!(name: "Personal Referral") }
    description { "#{Spree::Money.new(weighted_order_adjustment_amount)} off your first order" }
    after(:create) do |promotion, evaluator|
      promotion.rules << Spree::Promotion::Rules::FirstOrder.create!(promotion: promotion)
      promotion.rules << Spree::Promotion::Rules::OneUsePerUser.create!(promotion: promotion)
      promotion.save!
    end
  end
end
