module Spree
  module CheckoutControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
      include ControllerHelpers::Promotions

      helper_method :payment_error_message

      before_filter :assign_shipping_rate_of_delivery_window, only: :update, if: Proc.new { params['state'] == 'delivery' }
      before_filter :ensure_order_valid, only: :update, if: Proc.new { params['state'] == 'delivery' }

      before_action :apply_page_promotion, only: [:edit, :update]

      rescue_from Spree::Core::GatewayError, :with => :rescue_from_spree_gateway_error
    end

    module InstanceMethods
      private

      def ensure_order_valid
        return if @order.valid?
        flash[:error] = @order.errors.full_messages
        redirect_to checkout_state_path('delivery')
      end

      def assign_shipping_rate_of_delivery_window
        delivery_window_id = params['order']['shipments_attributes']['0']['delivery_window_id']
        return unless delivery_window_id
        shipment = @order.shipments.first
        delivery_window = shipment.delivery_windows.find(delivery_window_id)
        shipping_rate = shipment.shipping_rates.find_by(shipping_method: delivery_window.shipping_method)
        params['order']['shipments_attributes']['0']['selected_shipping_rate_id'] = shipping_rate.id
      end

      def rescue_from_spree_gateway_error(exception)
        flash['payment_error'] = exception.message
        super
      end

      def payment_error_message
        message = flash['payment_error'] || (params[:state] == "payment" && flash[:error])
        message.presence
      end
    end
  end
end
