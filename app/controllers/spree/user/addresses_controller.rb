module Spree
  class User::AddressesController < Spree::StoreController
    include ControllerHelpers::UserAuth
    before_action :authorize_user

    def show
      @address = spree_current_user.default_address || Address.factory({})
      session[:return_to] = request.env["HTTP_REFERER"] unless request.env["HTTP_REFERER"] == spree.account_address_path
    end

    def create
      @address = Spree::Address.new(address_params)
      unless @address.valid?
        flash.now[:error] = "#{@address.errors.full_messages.to_sentence}."
        render 'show'
        return
      end

      unless @address.valid?(:shipping)
        flash.now[:error] = "#{@address.errors.full_messages.to_sentence}."
        render 'show'
        return
      end

      @address = spree_current_user.save_in_address_book(@address.attributes, true)
      if @address.persisted?
        if delivery_window = @user.meal_subscription.try(:delivery_window)
          zone = Spree::Zone.match(@address)
          unless zone.delivery_windows.where(id: delivery_window.id).exists?
            @user.meal_subscription.update_attributes(delivery_window: zone.delivery_windows.first)
          end
        end
        flash[:success] = "Delivery address updated."
        redirect_to(session.delete(:return_to) || spree.account_path)
      else
        flash.now[:error] = "#{@address.errors.full_messages.to_sentence}."
        render 'show'
      end
    end

    private

      def address_params
        params
          .require(:address)
          .permit(:firstname, :lastname, :phone, :company, :address1, :address2, :city, :state, :zipcode, :delivery_instructions, :country_id, :state_id)
          .merge(country_id: Spree::Config[:default_country_id])
      end

  end
end
