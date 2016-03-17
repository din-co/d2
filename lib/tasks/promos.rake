namespace :promos do
  desc "Generate personalized referral URLs for each user that has ordered at least once"
  task :personal_referral => [:environment] do
    require 'factory_girl'
    require Rails.root.join('spec/support/factories/promotion_factory')
    personal_referral = Spree::PromotionCategory.find_or_create_by!(name: "Personal Referral")
    Spree::User.find(Spree::Order.uniq.pluck(:user_id)).each do |user|
      if promo = Spree::Promotion.find_by(promotion_category: personal_referral, user: user)
        Rails.logger.info "Skipping user #{user.id}: already has a personal referral promo: #{promo.path}"
        next
      end
      from = user.default_address.try(:firstname) || user.email
      FactoryGirl.create(:personalized_referral_promotion, {
        user_id: user.id,
        from: from,
        usage_limit: 10,
        weighted_order_adjustment_amount: 30
      })
    end
  end
end
