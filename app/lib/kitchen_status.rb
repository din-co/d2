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
  #         Open |---------------------------------\ 5pm Close
  # |------------|------------|------------|------------|------------|------------|------------|
  # S            M            Tu           W            Th           F            S            S

  # First second of Monday
  def opening_time
    Time.current.monday
  end

  # 5pm on Wednesday
  def closing_time
    opening_time.advance(days: 2, hours: 17)
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
end
