require 'stripe'
Stripe.api_version = "2016-03-07"
Stripe.api_key = Spree.default_payment_method.preferred_secret_key

module Spree
  class User::CardsController < Spree::StoreController
    include ControllerHelpers::UserAuth
    before_action :authorize_user
    before_action :set_payment_method

    def show
      @credit_card = @user.credit_cards.where(payment_method: @payment_method).default.first
    end

    def create
      customer = Stripe::Customer.create(
        email: @user.email,
        source: params[:gateway_token_id]
      )

      cc_params = credit_card_params.merge({
        gateway_customer_profile_id: customer.id,
        cc_type: credit_card_params[:cc_type].downcase,
        payment_method_id: @payment_method.id,
        default: true,
        address_attributes: address_params,
      })

      @user.bill_address_attributes = cc_params[:address_attributes]

      @credit_card = @user.credit_cards.create(cc_params)
      if @credit_card.persisted?
        flash[:success] = "New payment card added."
        UserAccountMailer.credit_card_changed_email(@credit_card).deliver_later
        redirect_to spree.account_path
      else
        flash.now[:error] = "#{@credit_card.errors.full_messages.to_sentence}."
        render 'show'
      end

    rescue Stripe::CardError => e
      flash.now[:error] = e.message
      render 'show'
    end

    private

      def set_payment_method
        @payment_method = Spree.default_payment_method
      end

      def credit_card_params
        params.require(:credit_card).permit(:name, :gateway_payment_profile_id, :month, :year, :cc_type, :last_digits)
      end

      def address_params
        params.require(:address).permit(:firstname, :lastname, :address1, :city, :zipcode, :state_name, :country_id)
      end

  end
end
