class SubscriptionOrderManager
  def initialize(available_meals)
    @available_meals = available_meals
    @shipment_date = Time.current.advance(days: Spree::MealSubscription.notification_lead_time_days)
  end

  attr_accessor :shipment_date

  def self.from_meal_names(meals)
    available_meals = {}
    meals.each do |meal_name, stock|
      product = Spree::Product.find_by(name: meal_name) || raise("Failed to find #{meal_name.inspect}")
      available_meals[product] = stock
    end
    new(available_meals)
  end

  def create_orders!(subscriptions)
    selections(subscriptions).map do |subscription, selected_products|
      create_order(subscription, selected_products)
    end
  end

  def print_selections(subscriptions)
    puts "Order for shipment on #{shipment_date.to_date}"
    selections(subscriptions).each do |sub, products|
      products.each do |product|
        notifications = [
          sub.user.default_address.firstname,
          sub.notification_email ? "(email)" : "(no email)",
          sub.notification_sms ? sub.user.default_address.phone : "(no SMS)"
        ].compact
        puts [ sub.user.email, product.try(:name) || "(missing)", notifications ].flatten.join("\t")
      end
    end
    nil
  end

  private

  def selections(subscriptions)
    MealSelector.new(subscriptions, @available_meals).selections
  end

  def create_order(subscription, products)
    user = subscription.user
    raise("Missing address") unless user.default_address
    raise("Missing credit card") unless user.default_credit_card
    order = Spree::Order.new({
      currency: Spree::Config[:currency],
      store: Spree::Store.default,
      email: user.email,
      user: user,
      created_by: user,
      shipment_date: shipment_date,
      bill_address: user.default_credit_card.address,
      payments_attributes: [{
        source: user.default_credit_card,
        payment_method_id: user.default_credit_card.payment_method_id
      }],
      ship_address: user.default_address,
      shipments_attributes: [{
        delivery_window_id: subscription.delivery_window_id
      }],
    })
    products.each do |product|
      if product
        order.contents.add(product.master)
      else
        order.errors.add(:base, "Unable to recommend #{subscription.meal_count} #{"meal".pluralize(subscription.meal_count)}")
      end
    end
    # order.ensure_updated_shipments
    # order.shipments.first.delivery_window_id = subscription.delivery_window_id
    # order.update_totals
    order.contents.advance
    order
  end
end
