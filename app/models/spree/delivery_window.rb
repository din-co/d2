module Spree
  class DeliveryWindow < Spree::Base
    belongs_to :shipping_method
    has_many :shipments, inverse_of: :delivery_window

    # FIXME: start_hour - lead_time_duration isn't robust to crossing midnight
    scope :available, -> { where("start_hour - lead_time_duration > ?", Time.zone.now.hour) }

    extend DisplayMoney
    money_methods :cost

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
