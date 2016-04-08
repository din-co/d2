Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = ENV["EAGER_LOAD_CLASSES"].present?

  # Show full error reports and disable caching.
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Define the default canonical domain name, and redirect to it if accessed via another domain.
  config.x.canonical_domain = ENV['CANONICAL_DOMAIN'] || 'local.flavvor.co'

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = true
  config.action_mailer.default_url_options = { host: config.x.canonical_domain, port: ENV['PORT'] || 3000 }
  config.action_mailer.logger = Rails.logger
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.smtp_settings = { address: 'localhost', port: 1025 }
  config.action_mailer.asset_host = "//#{config.action_mailer.default_url_options[:host]}:#{config.action_mailer.default_url_options[:port]}"

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = false

  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

  # enables or disables reloading of classes only when tracked files change.
  # By default tracks everything on autoload paths and is set to true.
  # If config.cache_classes is true, this option is ignored.
  config.reload_classes_only_on_change = false
end
