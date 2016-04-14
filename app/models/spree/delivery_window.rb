module Spree
  class DeliveryWindow < Spree::Base
    belongs_to :shipping_method
    has_many :shipments, inverse_of: :delivery_window
    has_many :orders, through: :shipments

    # FIXME: start_hour - lead_time_duration isn't robust to crossing midnight
    scope :available, -> { where("start_hour - lead_time_duration > ?", Time.zone.now.hour) }

    extend DisplayMoney
    money_methods :cost

    def currently_available?
      Time.zone.now < available_until
    end

    def available_until
      Time.zone.now.midnight.advance(hours: start_hour - lead_time_duration)
    end

    def cold_until
      Time.zone.now.midnight.advance(hours: start_hour + duration + 3) # 3 hours from end of delivery window
    end

    def to_s
      "#{format_offset(start_hour, false)}–#{format_offset(start_hour + duration)}"
    end

    def admin_display
      "#{to_s} (#{display_cost}) - #{lead_time_in_hours} lead time"
    end

    def lead_time_in_hours
      "#{lead_time_duration} hour".pluralize(lead_time_duration)
    end

    private

    def format_offset(offset, meridiem = true)
      datetime = Time.zone.now.beginning_of_day
      format = (meridiem) ? "%-l%P" : "%-l"
      (datetime + offset.hours).strftime(format)
    end
  end
end
