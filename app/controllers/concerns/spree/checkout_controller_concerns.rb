module Spree
  module CheckoutControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :apply_shipping_method, only: :update, if: :delivery_state?
    end

    module InstanceMethods
      private

      def apply_shipping_method
        delivery_window_id = params[:order][:shipments_attributes]['0'][:delivery_window_id]
        return unless delivery_window_id
        shipment = @order.shipments.first
        delivery_window = shipment.delivery_windows.find(delivery_window_id)
        shipping_rate = shipment.shipping_rates.find_by(shipping_method: delivery_window.shipping_method)
        params[:order][:shipments_attributes]['0']['selected_shipping_rate_id'] = shipping_rate.id
      end

      def delivery_state?
        params[:state] == 'delivery'
      end
    end
  end
end
