module Spree
  class DeliveryWindowZone < Spree::Base
    belongs_to :delivery_window, class_name: "Spree::DeliveryWindow", inverse_of: :delivery_window_zones
    belongs_to :zone, class_name: "Spree::Zone", inverse_of: :delivery_window_zones
  end
end
