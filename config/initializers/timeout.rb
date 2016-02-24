Rack::Timeout.timeout = Rails.env.production? ? 30 : 90  # seconds, 30s is Heroku's router timeout
Rack::Timeout::Logger.disable
