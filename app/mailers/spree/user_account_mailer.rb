module Spree
  class UserAccountMailer < BaseMailer

    helper 'application'

    def credit_card_changed_email(credit_card)
      @credit_card = credit_card
      @email_preheader = "#{Spree.t(@credit_card.cc_type)}, #{@credit_card.last_digits}"
      @title = "Credit Card Updated"
      subj = build_subject(@title)
      mail(to: @credit_card.user.email, from: from_address(@store), subject: subj)
    end

    def meal_preferences_changed_email(meal_preference)
      @meal_preference = meal_preference
      @proteins_sentence = Spree.t(:diet_suggestions, display_diet_names: @meal_preference.display_diet_names)
      @allergen_sentence = (@meal_preference.allergen_names.present?) ? Spree.t(:allergen_suggestions, display_allergen_names: @meal_preference.display_allergen_names) : ""
      @email_preheader = ActionView::Base.full_sanitizer.sanitize("#{@proteins_sentence} #{@allergen_sentence}")
      @title = "Meal Preferences Updated"
      subj = build_subject(@title)
      mail(to: @meal_preference.user.email, from: from_address(@store), subject: subj)
    end

    def delivery_address_changed_email(address, user)
      @address = address
      @text_address = @address.one_line
      @email_preheader = "#{@address.full_name}, #{@text_address}, #{@address.phone}"
      @title = "Delivery Address Updated"
      subj = build_subject(@title)
      mail(to: user.email, from: from_address(@store), subject: subj)
    end

    def meal_subscription_changed_email(meal_subscription)
      @meal_subscription = meal_subscription
      @title = (@meal_subscription.status == "paused") ? "Subscription Paused" : "Subscription Updated"
      subj = build_subject(@title)
      mail(to: @meal_subscription.user.email, from: from_address(@store), subject: subj)
    end

    private

      def build_subject(subject)
        @store = Spree::Store.default
        "#{@store.name} - #{subject}"
      end
  end
end
