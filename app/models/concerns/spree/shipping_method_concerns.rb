module Spree
  module ShippingMethodConcerns
    extend ActiveSupport::Concern

    included do
      has_many :delivery_windows, -> { order(:start_hour) }, through: :zones, class_name: "Spree::DeliveryWindow"
    end
  end
end
