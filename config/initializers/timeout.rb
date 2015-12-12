Rack::Timeout.timeout = 30  # seconds, to match Heroku's router timeout
Rack::Timeout::Logger.disable
