class KitchenStatus
  # Initialized from ENV['KITCHEN_STATUS'] in production
  def initialize(override=nil)
    @override = override.presence
  end

  def open?
    case overridden_status
    when :open
      return true
    when :closed
      return false
    else
      Time.current.between?(opening_time, closing_time)
    end
  end

  def status
    (overridden_status || open? ? :open : :closed).to_s
  end

  # Relative time methods describing a kitchen that is open part of the week and closed the other part
  # Orders      |--------------------------------------------| 12pm Close
  # Deliveries               |--------------------------------------| 12am Close
  #             |------------|------------|------------|------------|------------|------------|------------|
  #             S            M            Tu           W            Th           F            S            S


  # First second of Sunday
  def opening_time
    Time.current.beginning_of_week(:sunday)
  end

  # 12pm on Wednesday
  def closing_time
    opening_time.advance(days: 3, hours: 12)
  end

  def shipment_opening_time
    opening_time.advance(days: 1).midnight # First second of Monday
  end

  def shipment_closing_time
    closing_time.end_of_day # Last second of Wednesday
  end

  def shipment_dates_available
    t = shipment_opening_time
    dates = []
    ordering_days.to_i.times do
      dates << t.to_date if Time.current.advance(days: -1).midnight < t && t <= shipment_closing_time
      t = t.advance(days: 1)
    end
    if overridden_status == :open # FIXME: should this be the *only* day we show when the kitchen is forced open?
      tomorrow = 1.day.from_now.to_date
      dates.unshift(tomorrow) unless dates.include?(tomorrow)
    end
    dates
  end

  # First second of next Monday
  def next_opens
    opening_time.advance(weeks: 1)
  end

  private
  # Returns :open or :closed when override is present, otherwise nil.
  def overridden_status
    if @override
      @override.downcase.to_sym
    end
  end

  def ordering_days
    ((closing_time - opening_time) / 60 / 60 / 24).round
  end
end