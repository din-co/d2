require 'carmen'

# This file overrides the built-in countries.rb to only load the United States.

country = Carmen::Country.named('United States')
usa = Spree::Country.create!({
    name: country.name,
    iso3: country.alpha_3_code,
    iso: country.alpha_2_code,
    iso_name: country.name.upcase,
    numcode: country.numeric_code,
    states_required: country.subregions?
})

Spree::Config[:default_country_id] = usa.id
