module Spree
  module UserConcerns
    extend ActiveSupport::Concern

    included do
      has_one :meal_preference, class_name: 'Spree::MealPreference' #, dependent: :destroy

      has_one :personal_referral_promo, -> { where promotion_category: Spree::PromotionCategory.find_by!(name: "Personal Referral") }, class_name: 'Spree::Promotion'
    end
  end
end
