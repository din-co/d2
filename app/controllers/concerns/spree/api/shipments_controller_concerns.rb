module Spree
  module Api
    module ShipmentsControllerConcerns
      extend ActiveSupport::Concern

      included do
        prepend(InstanceMethods)

        before_filter :select_delivery_window_for_shipping_rate, only: :update
      end

      module InstanceMethods
        private
        def select_delivery_window_for_shipping_rate
          shipping_rate_id = params["shipment"]["selected_shipping_rate_id"]
          shipping_rate = Spree::ShippingRate.find_by(id: shipping_rate_id)
          return unless shipping_rate.present?
          delivery_window = Spree::DeliveryWindow.find_by(shipping_method_id: shipping_rate.shipping_method_id)
          return unless delivery_window.present?
          params["shipment"]["delivery_window_id"] = delivery_window.id
        end
      end
    end
  end
end
