class SubscriptionOrderManager
  def initialize(available_meals)
    @available_meals = available_meals
  end

  def self.from_meal_names(meals)
    available_meals = {}
    meals.each do |meal_name, stock|
      product = Spree::Product.find_by(name: meal_name) || raise("Failed to find #{meal_name.inspect}")
      available_meals[product] = stock
    end
    new(available_meals)
  end

  def print_selections(subscriptions)
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

  def meal_preferences(subscriptions)
    Spree::MealPreference.where(user_id: subscriptions.pluck(:user_id))
  end

  def selections(subscriptions)
    MealSelector.new(meal_preferences(subscriptions), subscriptions, @available_meals).selections
  end
end
