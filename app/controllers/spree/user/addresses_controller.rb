module Spree
  class User::AddressesController < Spree::StoreController
    include ControllerHelpers::UserAuth
    before_action :authorize_user

    def show
      @address = spree_current_user.default_address || Address.factory({})
    end

    def create
      @address = spree_current_user.save_in_address_book(address_params, true)
      if @address.persisted?
        flash[:success] = "Delivery address updated."
        redirect_to spree.account_path
      else
        flash.now[:error] = "#{@address.errors.full_messages.to_sentence}."
        render 'show'
      end
    end

    private

      def address_params
        params.require(:address).permit(:firstname, :lastname, :phone, :company, :address1, :address2, :city, :state, :zipcode, :delivery_instructions, :country_id, :state_id)
      end

  end
end
