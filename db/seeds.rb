# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with bin/rake db:seed

# Loads data from each gem's db/default/spree/*.rb files, unless overridden by files of
# the same name in #{Rails.root}/db/default/spree/ (which we do).
Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)
Spree::Config[:default_country_id] = Spree::Country.find_by!(iso3: "USA").id

# Create Taxons
taxonomy_pages = Spree::Taxonomy.find_or_create_by!(name: 'Pages')
taxon_pages = Spree::Taxon.find_or_create_by!(name: 'Pages', taxonomy_id: taxonomy_pages.id)
Spree::Taxon.find_or_create_by!(name: "Home", parent_id: taxon_pages.id, taxonomy_id: taxonomy_pages.id)

taxonomy_restaurants = Spree::Taxonomy.find_or_create_by!(name: 'Restaurants')
taxon_restaurants = Spree::Taxon.find_or_create_by!(name: 'Restaurants', taxonomy_id: taxonomy_restaurants.id)

taxonomy_chefs = Spree::Taxonomy.find_or_create_by!(name: 'Chefs')
taxon_chefs = Spree::Taxon.find_or_create_by!(name: 'Chefs', taxonomy_id: taxonomy_chefs.id)

taxonomy_diets = Spree::Taxonomy.find_or_create_by!(name: 'Diets')
taxon_diets = Spree::Taxon.find_or_create_by!(name: 'Diets', taxonomy_id: taxonomy_diets.id)
Spree::Taxon.find_or_create_by!(name: "vegetarian", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "vegetarian description here."
end
Spree::Taxon.find_or_create_by!(name: "vegan", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "vegan description here."
end
Spree::Taxon.find_or_create_by!(name: "soy-free", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "soy-free description here."
end
Spree::Taxon.find_or_create_by!(name: "dairy-free", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "dairy-free description here."
end
Spree::Taxon.find_or_create_by!(name: "nut-free", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "nut-free description here."
end
Spree::Taxon.find_or_create_by!(name: "spicy", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "spicy description here."
end
Spree::Taxon.find_or_create_by!(name: "paleo", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "paleo description here."
end
Spree::Taxon.find_or_create_by!(name: "gluten-free", parent_id: taxon_diets.id, taxonomy_id: taxonomy_diets.id) do |t|
  t.description = "gluten-free description here."
end

taxonomy_allergens = Spree::Taxonomy.find_or_create_by!(name: 'Allergens')
taxon_allergens = Spree::Taxon.find_or_create_by!(name: 'Allergens', taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "milk", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "eggs", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "fish", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "shellfish", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "tree nuts", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "peanuts", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "wheat", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)
Spree::Taxon.find_or_create_by!(name: "soybeans", parent_id: taxon_allergens.id, taxonomy_id: taxonomy_allergens.id)

taxonomy_proteins = Spree::Taxonomy.find_or_create_by!(name: 'Proteins')
taxon_proteins = Spree::Taxon.find_or_create_by!(name: 'Proteins', taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "beef", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "lamb", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "pork", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "poultry", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "rabbit", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "seafood", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "fish", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)
Spree::Taxon.find_or_create_by!(name: "tofu", parent_id: taxon_proteins.id, taxonomy_id: taxonomy_proteins.id)

taxonomy_pantry = Spree::Taxonomy.find_or_create_by!(name: 'Pantry')
taxon_pantry = Spree::Taxon.find_or_create_by!(name: 'Pantry', taxonomy_id: taxonomy_pantry.id)
Spree::Taxon.find_or_create_by!(name: "high-heat oil", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "high-heat oil description here."
end
Spree::Taxon.find_or_create_by!(name: "olive oil", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "olive oil description here."
end
Spree::Taxon.find_or_create_by!(name: "salt", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "salt description here."
end
Spree::Taxon.find_or_create_by!(name: "black pepper", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "black pepper description here."
end
Spree::Taxon.find_or_create_by!(name: "butter", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "butter description here."
end
Spree::Taxon.find_or_create_by!(name: "sugar", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "sugar description here."
end
Spree::Taxon.find_or_create_by!(name: "flour", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "flour description here."
end
Spree::Taxon.find_or_create_by!(name: "vinegar", parent_id: taxon_pantry.id, taxonomy_id: taxonomy_pantry.id) do |t|
  t.description = "vinegar description here."
end

taxonomy_equipment = Spree::Taxonomy.find_or_create_by!(name: 'Equipment')
taxon_equipment = Spree::Taxon.find_or_create_by!(name: 'Equipment', taxonomy_id: taxonomy_equipment.id)
Spree::Taxon.find_or_create_by!(name: "baking sheet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "baking sheet description here."
end
Spree::Taxon.find_or_create_by!(name: "grater", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "grater description here."
end
Spree::Taxon.find_or_create_by!(name: "rubber spatula", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "rubber spatula description here."
end
Spree::Taxon.find_or_create_by!(name: "wisk", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "wisk description here."
end
Spree::Taxon.find_or_create_by!(name: "paper towels", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "paper towels description here."
end
Spree::Taxon.find_or_create_by!(name: "bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "large bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "medium bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "medium bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "small bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "small skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "medium skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "medium skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "large skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "non-stick skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "non-stick skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "ovenproof skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "ovenproof skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "small ovenproof skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small ovenproof skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "medium ovenproof skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "medium ovenproof skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "large ovenproof skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large ovenproof skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "saucepan description here."
end
Spree::Taxon.find_or_create_by!(name: "small saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small saucepan description here."
end
Spree::Taxon.find_or_create_by!(name: "medium saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "medium saucepan description here."
end
Spree::Taxon.find_or_create_by!(name: "large saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large saucepan description here."
end

# Dish Prototype and Product Properties
dish = Spree::Prototype.find_or_create_by!(name: 'Dish - standard')
dish.properties += [
  Spree::Property.find_or_create_by!(name: 'tagline', presentation: 'Tagline'),
  Spree::Property.find_or_create_by!(name: 'time-minutes', presentation: 'Time (minutes)'),
  Spree::Property.find_or_create_by!(name: 'shelf-life-days', presentation: 'Shelf Life (days)'),
  Spree::Property.find_or_create_by!(name: 'components', presentation: 'Components'),
  Spree::Property.find_or_create_by!(name: 'directions', presentation: 'Directions'),
  Spree::Property.find_or_create_by!(name: 'ingredients', presentation: 'Ingredients'),
  Spree::Property.find_or_create_by!(name: 'callout-1', presentation: 'Callout-1'),
  Spree::Property.find_or_create_by!(name: 'callout-2', presentation: 'Callout-2'),
  Spree::Property.find_or_create_by!(name: 'sidebar', presentation: 'Sidebar'),
]

usa = Spree::Country.find_by(iso: 'US') || Spree::Country.default

# Default stock location to hold stocks of products
Spree::StockLocation.find_or_create_by!(name: 'Default') do |s|
  s.default = true
  s.country = usa
end

# Shipping Zones, Categories and Methods required to create products
standard_shipping_category = Spree::ShippingCategory.find_or_create_by!(name: "Dish - standard")

sf_zone = Spree::Zone.find_by!(name: "San Francisco")
bay_area_zones = ["East Bay", "North Bay", "Peninsula"].map { |name| zone = Spree::Zone.find_by!(name: name) }
delivery_windows = [
  {zones: [sf_zone], window: {start_hour: 13, duration: 4, lead_time_duration: 1, cost: 4.99, currency: "USD"}}, # 1pm - 5pm, order by 12pm
  {zones: [sf_zone], window: {start_hour: 18, duration: 2, lead_time_duration: 1, cost: 6.99, currency: "USD"}}, # 6pm - 8pm, order by 5pm
  {zones: [sf_zone], window: {start_hour: 18, duration: 1, lead_time_duration: 1, cost: 8.99, currency: "USD"}}, # 6pm - 7pm, order by 5pm
  {zones: [sf_zone], window: {start_hour: 19, duration: 1, lead_time_duration: 2, cost: 8.99, currency: "USD"}}, # 7pm - 8pm, order by 5pm

  {zones: bay_area_zones, window: {start_hour: 13, duration: 4, lead_time_duration: 1, cost: 6.99, currency: "USD"}} # 1pm - 5pm, order by 12pm
]

delivery_windows.each do |d|
  shipping_method = Spree::ShippingMethod.create!(name: "#{d[:window][:duration]}-Hour Window", code: d[:zones].map(&:name).join(", ")) do |sm|
    sm.shipping_categories = [standard_shipping_category]
    sm.build_calculator({
      type: "Spree::Calculator::Shipping::PriceSack",
      preferred_minimal_amount: 60,
      preferred_normal_amount: d[:window][:cost],
      preferred_discount_amount: [d[:window][:cost] - 5, 0].max,
      preferred_currency: d[:window][:currency],
    })
    d[:zones].each do |z|
      sm.shipping_method_zones.build(zone: z)
    end
  end
  Spree::DeliveryWindow.create!(d[:window].merge(shipping_method: shipping_method))
end

# Stripe Payment Gateway
Spree::Gateway::StripeGateway.find_or_create_by({
  name: "Stripe",
  description: "Credit card payments via Stripe",
  active: true,
  auto_capture: true,
}) do |g|
  g.preferred_server = "test"
  g.preferred_test_mode = true
  g.preferred_secret_key = "sk_test_0wqvetWX3zDayzZc8KSggjhO"
  g.preferred_publishable_key = "pk_test_RtnEyAHZVnP5lTdheh6UuR9W"
end

if ENV['INCLUDE_SAMPLES']
  load Rails.root.join('db/samples.rb')
end
