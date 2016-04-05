module Spree
  class UserAccountMailer < BaseMailer

    helper 'application'

    def credit_card_changed_email(credit_card)
      @credit_card = credit_card
      subject = build_subject("Credit Card Updated")
      mail(to: @credit_card.user.email, from: from_address(@store), subject: subject)
    end

    def meal_preferences_changed_email(meal_preference)
      @meal_preference = meal_preference
      subject = build_subject("Meal Preferences Updated")
      mail(to: @meal_preference.user.email, from: from_address(@store), subject: subject)
    end

    def delivery_address_changed_email(address, user)
      @address = address
      subject = build_subject("Delivery Address Updated")
      mail(to: user.email, from: from_address(@store), subject: subject)
    end

    def meal_subscription_changed_email(meal_subscription)
      @sub = meal_subscription
      @subject_text = (@sub.status == "paused") ? "Subscription Paused" : "Subscription Updated"
      subject = build_subject(@subject_text)
      mail(to: @sub.user.email, from: from_address(@store), subject: subject)
    end

    private

      def build_subject(subject)
        @store = Spree::Store.default
        "#{@store.name} - #{subject}"
      end
  end
end
