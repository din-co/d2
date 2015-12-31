module Spree
  class DeliveryWindow < Spree::Base
    HOUR_OFFSET = 12

    def to_s
      range_start = start_hour - HOUR_OFFSET
      range_end = range_start + duration
      "#{range_start} to #{range_end}" 
    end
  end
end
