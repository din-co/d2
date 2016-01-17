namespace :legacy do
  desc "Load legacy data into the current Rails.env"
  task load: :environment do
    Legacy::Data.load!
  end

  desc "Complete Stripe payment method data"
  task update_payment_profiles: :environment do
    Spree::CreditCard.where(gateway_payment_profile_id: nil).find_each do |card|
      customer = StripeCustomer.new(card.gateway_customer_profile_id)
      customer.update_payment_profile!(card)
    end
  end
end
