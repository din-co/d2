module Spree
  module ShipmentConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :selected_delivery_window, foreign_key: :delivery_window_id, class_name: "Spree::DeliveryWindow"

      has_many :delivery_windows, through: :shipping_methods
    end
  end
end
