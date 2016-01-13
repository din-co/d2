# Configure Solidus Preferences
# See http://docs.solidus.io/Spree/AppConfiguration.html for details

Spree.config do |config|
  # Without this preferences are loaded and persisted to the database. This
  # changes them to be stored in memory.
  # This will be the default in a future version.
  config.use_static_preferences!

  # Core:

  # Default country and currency for new sites
  config.currency = "USD"
  config.default_country_id = 1

  # from address for transactional emails
  config.mails_from = "cook@din.co"

  # Uncomment to stop tracking inventory levels in the application
  # config.track_inventory_levels = false

  # When set, product caches are only invalidated when they fall below or rise
  # above the inventory_cache_threshold that is set. Default is to invalidate cache on
  # any inventory changes.
  # config.inventory_cache_threshold = 3


  # Frontend:

  # Custom logo for the frontend
  # config.logo = "logo/solidus_logo.png"

  # Template to use when rendering layout
  # config.layout = "spree/layouts/spree_application"

  # Show shipping instructions in checkout
  config.shipping_instructions = true


  # Admin:

  # Custom logo for the admin
  # config.admin_interface_logo = "logo/solidus_logo.png"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.
  #
  # config.static_model_preferences.add(
  #   Spree::Gateway::StripeGateway,
  #   'stripe_env_credentials',
  #   secret_key: ENV['STRIPE_SECRET_KEY'],
  #   publishable_key: ENV['STRIPE_PUBLISHABLE_KEY'],
  #   server: Rails.env.production? ? 'production' : 'test',
  #   test: !Rails.env.production?
  # )
end

Spree::Config[:default_country_id] = begin
  (Spree::Country.find_by(iso3: "USA") || Spree::Country.first).try!(:id)
rescue ActiveRecord::StatementInvalid => e
  Rails.logger.error e.message
end

# Uploaded image assets
attachment_config = {
  styles: {
    detail:   "1920x1080",
    menu:     "960x540",
    mini:     "48x48>",
  },
  # default_url:    "/spree/:class/:id/:style/:basename.:extension", # used for items lacking an image
  default_style:  :detail
}
if Rails.env.production?
  attachment_config = attachment_config.merge({
    s3_credentials: {
      access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
      secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
      bucket:            ENV['S3_BUCKET_NAME']
    },

    storage:        :s3,
    s3_headers:     { "Cache-Control" => "max-age=31557600" },
    s3_protocol:    "https",
    bucket:         ENV['S3_BUCKET_NAME'],
    url:            ":s3_domain_url",
    path:           "/spree/:class/:id/:style/:basename.:extension",
  })
end

attachment_config.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
end

Spree::PermittedAttributes.shipment_attributes << :delivery_window_id

Spree.user_class = "Spree::LegacyUser"
