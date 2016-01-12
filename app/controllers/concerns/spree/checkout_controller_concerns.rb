module Spree
  module CheckoutControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :assign_shipping_rate_of_delivery_window, only: :update, if: Proc.new { params['state'] == 'delivery' }
      before_filter :ensure_order_valid, only: :update, if: Proc.new { params['state'] == 'delivery' }
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
    end
  end
end
