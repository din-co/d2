module Spree
  class ZoneDeliveryWindow < Spree::Base
    belongs_to :delivery_window, class_name: "Spree::DeliveryWindow"
    belongs_to :zone, class_name: "Spree::Zone"
  end
end