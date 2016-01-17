require 'stripe'
Stripe.api_version = "2015-10-16"

class StripeCustomer
  def initialize(customer_id)
    @customer_id = customer_id
  end

  def get_customer
    @customer ||= Stripe::Customer.retrieve(@customer_id)
  end

  def default_source_id
    get_customer.default_source
  end

  def sources
    get_customer.sources
  end

  def default_card_source
    default = sources.detect { |source| source.id == default_source_id }
    if default.try(:object) == "card"
      return default
    else
      sources.detect { |source| source.object == "card" }
    end
  end

  def spree_credit_card_data
    card = default_card_source
    return {} if card.blank?
    {
      name: card.name,
      month: card.exp_month,
      year: card.exp_year,
      gateway_payment_profile_id: card.id,
    }
  end

  def update_payment_profile!(card)
    unless default_card_source
      Rails.logger.info "No default payment card for user: #{card.user_id}"
      return
    end

    if card.update(spree_credit_card_data)
      Rails.logger.info "Updated user: #{card.user_id}/#{card.gateway_customer_profile_id} with token: #{card.gateway_payment_profile_id} "
    else
      Rails.logger.info "Failed to update user: #{card.user_id}/#{card.gateway_customer_profile_id} errors: #{card.errors.messages}"
    end
  end
end
