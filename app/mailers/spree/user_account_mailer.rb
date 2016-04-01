module Spree
  class UserAccountMailer < BaseMailer
    def credit_card_changed_email(credit_card)
      @credit_card = credit_card
      @store = Spree::Store.default
      subject = "#{@store.name} - Credit Card Updated"
      mail(to: @credit_card.user.email, from: from_address(@store), subject: subject)
    end
  end
end
