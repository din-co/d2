module Spree
  class DeliveryWindow < Spree::Base
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
