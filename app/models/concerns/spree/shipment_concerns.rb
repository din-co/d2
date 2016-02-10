module Spree
  module ShipmentConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      belongs_to :selected_delivery_window, foreign_key: :delivery_window_id, class_name: "Spree::DeliveryWindow"

      has_many :delivery_windows, through: :shipping_methods
    end

    module InstanceMethods
      def pre_shipment_manifest
        Spree::ShippingManifest.new(inventory_units: inventory_units.shippable).items
      end
    end
  end
end
