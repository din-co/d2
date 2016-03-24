class TimeTravel
  def self.to(target)
    zone = Time.find_zone('Pacific Time (US & Canada)')
    default = zone.now.beginning_of_day
    t = zone.parse(target) || default rescue default
    puts "NOTICE: Time traveling to #{t}"
    Timecop.travel(t)
  end
end
