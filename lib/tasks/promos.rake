namespace :promos do
  desc "Generate personalized referral URLs for each user that has ordered at least once"
  task :personal_referral => [:environment] do
    personal_referral = Spree::PromotionCategory.find_or_create_by!(name: "Personal Referral")
    Spree::User.find(Spree::Order.uniq.pluck(:user_id)).each do |user|
      if promo = Spree::Promotion.find_by(promotion_category: personal_referral, user: user)
        Rails.logger.info "Skipping user #{user.id}: already has a personal referral promo: #{promo.path}"
        next
      end
      user.ensure_personal_referral_promo
    end
  end
end
