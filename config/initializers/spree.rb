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
  config.company = true


  # Admin:

  # Custom logo for the admin
  # config.admin_interface_logo = "logo/solidus_logo.png"

  # Gateway credentials can be configured statically here and referenced from
  # the admin. They can also be fully configured from the admin.

  # Force Stripe test server unless really in production
  unless Rails.configuration.x.true_production_instance
    config.static_model_preferences.add(
      Spree::Gateway::StripeGateway,
      'stripe_env_credentials',
      secret_key: 'sk_test_0wqvetWX3zDayzZc8KSggjhO',
      publishable_key: 'pk_test_RtnEyAHZVnP5lTdheh6UuR9W',
      server: 'test',
      test: true,
    )
  end
end

Spree::Config[:default_country_id] = begin
  (Spree::Country.find_by(iso3: "USA") || Spree::Country.first).try!(:id)
rescue ActiveRecord::StatementInvalid => e
  Rails.logger.error e.message
  1
end

# Uploaded image assets
paperclip_config = {
  preserve_files: "true",
}
if Rails.env.production?
  paperclip_config[:storage]     = :s3
  paperclip_config[:s3_headers]  = { "Cache-Control" => "max-age=31557600" }
  paperclip_config[:s3_protocol] = 'https'
  paperclip_config[:bucket]      = ENV['S3_BUCKET_NAME']
  paperclip_config[:s3_credentials] = {
    access_key_id:     ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_SECRET_ACCESS_KEY'],
    bucket:            ENV['S3_BUCKET_NAME'],
  }

  if Rails.configuration.action_controller.asset_host.present?
    paperclip_config[:url]           = ':s3_alias_url'
    paperclip_config[:s3_host_alias] = Rails.configuration.action_controller.asset_host
  else
    paperclip_config[:url] = ':s3_path_url'
  end

  if TRUE_PRODUCTION_INSTANCE
    paperclip_config[:path] = "/:class/:attachment/:id_partition/:style/:filename"
  else
    paperclip_config[:path] = "/staging/:class/:attachment/:id_partition/:style/:filename"
    paperclip_config[:s3_storage_class] = :reduced_redundancy
  end
end

image_attachment_config = paperclip_config.merge({
  styles: {
    detail: '1920x1080',
    menu:   '960x540',
    small:  '160x90>',
    mini:   '48x48>',
  },
  default_style:  :detail,
})
image_attachment_config.each do |key, value|
  Spree::Image.attachment_definitions[:attachment][key.to_sym] = value
end

taxon_icon_config = paperclip_config.merge({
  styles: {
    detail: '1920x1080',
    menu:   '960x540',
    small:  '160x90>',
  },
  default_style: :small,
})
taxon_icon_config.each do |key, value|
  Spree::Taxon.attachment_definitions[:icon][key.to_sym] = value
end


Spree::PermittedAttributes.shipment_attributes << :delivery_window_id

# The name is strange, but this is the default Spree implementation of User.
# This class is intended to be modified by extensions (ex. spree_auth_devise)
Spree.user_class = "Spree::LegacyUser"
