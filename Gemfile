source 'https://rubygems.org'
ruby '2.3.0'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 4.2'
# Use postgresql as the database for Active Record
gem 'pg'
# Use Bootstrap and Sass for stylesheets
gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'autoprefixer-rails'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development


# Non-Rails additions
gem 'mysql2', '~> 0.3.20'
gem 'solidus', '~> 1.2.2'
gem 'solidus_auth_devise'
gem 'solidus_gateway'
gem 'stripe', git: 'https://github.com/stripe/stripe-ruby'
gem 'puma'
gem 'rack-timeout'
gem 'sprockets-rails'

# Twitter Common Locale Data Repository
gem 'twitter_cldr'

gem 'aws-sdk', '< 2.0'
gem 'intercom-rails'
gem 'devise_masquerade'

gem 'rails_12factor', group: [:development, :production]
gem 'lograge'
gem 'newrelic_rpm'

gem 'font_assets' # for CORS
gem 'immutable-struct'
gem 'rack-rewrite'

gem 'kronic'

gem 'timecop'

group :test do
  gem 'database_cleaner'
  gem 'rspec-rails'
  gem 'rspec_junit_formatter'
  gem 'capybara-puma'
  gem 'launchy'
  gem 'poltergeist'
  gem 'capybara-screenshot'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'

  # Mailcatcher sets up an SMTP server to receive and display emails, but it recommends NOT adding it to the Gemfile
  # gem 'mailcatcher'

  # Pry makes the Rails console much better
  gem 'pry-rails'

  # Some test gems are handy in development, especially in the console
  gem 'factory_girl'
  gem 'ffaker'

  # Generate diagrams
  gem "rails-erd"
end
# END Non-Rails additions

