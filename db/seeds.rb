# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)


Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Taxons required for proper functionality
taxonomy = Spree::Taxonomy.find_or_create_by!(name: 'Restaurants')
Spree::Taxon.find_or_create_by!(name: 'Restaurants') do |t|
  t.taxonomy_id = taxonomy.id
end
taxonomy = Spree::Taxonomy.find_or_create_by!(name: 'Chefs')
Spree::Taxon.find_or_create_by!(name: 'Chefs') do |t|
  t.taxonomy_id = taxonomy.id
end
taxonomy = Spree::Taxonomy.find_or_create_by!(name: 'Diets')
Spree::Taxon.find_or_create_by!(name: 'Diets') do |t|
  t.taxonomy_id = taxonomy.id
end
taxonomy = Spree::Taxonomy.find_or_create_by!(name: 'Pantry')
Spree::Taxon.find_or_create_by!(name: 'Pantry') do |t|
  t.taxonomy_id = taxonomy.id
end
