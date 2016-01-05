module Spree
  module CheckoutControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :add_delivery_window_id_to_shipment_attributes, only: :update, if: :delivery_state?
      before_filter :apply_shipping_method, only: :update, if: :delivery_state?
    end

    module InstanceMethods
      private

      def add_delivery_window_id_to_shipment_attributes
        return if Spree::PermittedAttributes.shipment_attributes.include?(:delivery_window_id)
        Spree::PermittedAttributes.shipment_attributes << :delivery_window_id
      end

      def apply_shipping_method
        # TODO: This'll do for now
        delivery_window = Spree::DeliveryWindow.where(id: params[:order][:shipments_attributes]['0'][:delivery_window_id]).first
        shipping_method = Spree::ShippingMethod.where("name like '%#{delivery_window.duration}%'").first
        params[:order][:shipments_attributes]['0']['selected_shipping_rate_id'] = shipping_method.shipping_rates.first.id
      end

      def delivery_state?
        params[:state] == 'delivery'
      end
    end
  end
end
