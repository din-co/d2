module Spree
  class DeliveryWindow < Spree::Base
    has_many :shipments, :class_name => "Spree::Shipment", inverse_of: :delivery_window
    has_many :delivery_window_zones, :class_name => "Spree::DeliveryWindowZone"
    has_many :zones, through: :delivery_window_zones

    scope :available, -> { where("start_hour - lead_time_duration > ?", Time.now.hour) }

    def to_s
      "#{format_offset(start_hour)} - #{format_offset(start_hour + duration)}"
    end

    def lead_time_in_hours
      "#{lead_time_duration} hours"
    end

    private

    def format_offset(offset)
      datetime = Time.now.beginning_of_day

      (datetime + offset.hours).strftime("%l%P")
    end
  end
end
