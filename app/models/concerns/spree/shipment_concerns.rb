module Spree
  module ShipmentConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :delivery_window, class_name: "Spree::DeliveryWindow", inverse_of: :shipments
    end
  end
end
