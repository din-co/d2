module Spree
  class UserAccountMailer < BaseMailer

    helper 'application'

    def credit_card_changed_email(credit_card)
      @credit_card = credit_card
      @email_preheader = "#{Spree.t(@credit_card.cc_type)}, #{@credit_card.last_digits} #{@credit_card.month}/#{@credit_card.year}"
      @title = "Credit Card Updated"
      subject = build_subject(@title)
      mail(to: @credit_card.user.email, from: from_address(@store), subject: subject)
    end

    def meal_preferences_changed_email(meal_preference)
      @meal_preference = meal_preference
      @proteins_sentence = Spree.t(:diet_suggestions, display_diet_names: @meal_preference.display_diet_names)
      @allergen_sentence = (@meal_preference.allergen_names.present?) ? Spree.t(:allergen_suggestions, display_allergen_names: @meal_preference.display_allergen_names) : ""
      @email_preheader = "#{ActionView::Base.full_sanitizer.sanitize(@proteins_sentence)} #{ActionView::Base.full_sanitizer.sanitize(@allergen_sentence)}"
      @title = "Meal Preferences Updated"
      subject = build_subject(@title)
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
