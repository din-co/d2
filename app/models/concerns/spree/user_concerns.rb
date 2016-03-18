module Spree
  module UserConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      has_one :meal_preference, class_name: 'Spree::MealPreference' #, dependent: :destroy
      has_one :personal_referral_promo, -> { where promotion_category: Spree::PromotionCategory.find_by!(name: "Personal Referral") }, class_name: 'Spree::Promotion'

      def generate_random_code
        Array.new(4) { sample_characters.sample }.join
      end

      def sample_characters
        @sample_characters ||= ('a'..'z').to_a + (0..9).to_a
      end

      PERSONAL_REFERRAL_PROMO_AMOUNT = 30
    end

    module InstanceMethods
      def ensure_personal_referral_promo
        return personal_referral_promo if personal_referral_promo.present?
        transaction do
          from = default_address.try(:firstname) || email
          begin
            promo = create_personal_referral_promo!({
              name: "courtesy of #{from}",
              promotion_category: personal_referral_category,
              description: "#{Spree::Money.new(PERSONAL_REFERRAL_PROMO_AMOUNT)} off your first order" ,
              path: [from.parameterize, PERSONAL_REFERRAL_PROMO_AMOUNT.to_s, "off", self.class.generate_random_code].join('-'),
              usage_limit: 10,
            })
          rescue ActiveRecord::RecordNotUnique
            retry
          end

          promo.promotion_rules << Spree::Promotion::Rules::FirstOrder.new
          # promo.promotion_rules << Spree::Promotion::Rules::OneUsePerUser.new # redundant

          calculator = Spree::Calculator::FlatRate.new
          calculator.preferred_amount = amount
          promo.promotion_actions << Spree::Promotion::Actions::CreateAdjustment.new(calculator: calculator)
          promo
        end
      end

    private

      def personal_referral_category
        Spree::PromotionCategory.find_or_create_by!(name: "Personal Referral")
      end
    end
  end
end
