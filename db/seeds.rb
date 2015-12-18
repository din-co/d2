# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Spree::Core::Engine.load_seed if defined?(Spree::Core)
Spree::Auth::Engine.load_seed if defined?(Spree::Auth)

# Create Taxons
taxonomy_restaurants = Spree::Taxonomy.find_or_create_by!(name: 'Restaurants')
taxon_restaurants = Spree::Taxon.find_or_create_by!(name: 'Restaurants', taxonomy_id: taxonomy_restaurants.id)
Spree::Taxon.find_or_create_by!(name: "Kin Khao", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Kin Khao restaurant description here."
end
Spree::Taxon.find_or_create_by!(name: "Souvla", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Souvla restaurant description here."
end
Spree::Taxon.find_or_create_by!(name: "Uma Casa", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Uma Casa restaurant description here."
end

taxonomy_chefs = Spree::Taxonomy.find_or_create_by!(name: 'Chefs')
taxon_chefs = Spree::Taxon.find_or_create_by!(name: 'Chefs', taxonomy_id: taxonomy_chefs.id)
Spree::Taxon.find_or_create_by!(name: "Pim Techamuanvivit", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Pim Techamuanvivit bio here."
end
Spree::Taxon.find_or_create_by!(name: "Charles Billies", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Charles Billies bio here."
end
Spree::Taxon.find_or_create_by!(name: "Telmo Faria", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Telmo Faria bio here."
end

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
Spree::Taxon.find_or_create_by!(name: "bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "large bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "small bowl", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small bowl description here."
end
Spree::Taxon.find_or_create_by!(name: "chef knife", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "chef knife description here."
end
Spree::Taxon.find_or_create_by!(name: "paring knife", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "paring knife description here."
end
Spree::Taxon.find_or_create_by!(name: "cutting board", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "cutting board description here."
end
Spree::Taxon.find_or_create_by!(name: "skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "small skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small skillet description here."
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
Spree::Taxon.find_or_create_by!(name: "large ovenproof skillet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large ovenproof skillet description here."
end
Spree::Taxon.find_or_create_by!(name: "small saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "small saucepan description here."
end
Spree::Taxon.find_or_create_by!(name: "large saucepan", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "large saucepan description here."
end
Spree::Taxon.find_or_create_by!(name: "baking sheet", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "baking sheet description here."
end
Spree::Taxon.find_or_create_by!(name: "grater", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "grater description here."
end
Spree::Taxon.find_or_create_by!(name: "rubber spatula", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "rubber spatula description here."
end
Spree::Taxon.find_or_create_by!(name: "paper towels", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "paper towels description here."
end
Spree::Taxon.find_or_create_by!(name: "fork", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "fork description here."
end
Spree::Taxon.find_or_create_by!(name: "plate", parent_id: taxon_equipment.id, taxonomy_id: taxonomy_equipment.id) do |t|
  t.description = "plate description here."
end

# Dish Prototype and Product Properties
dish = Spree::Prototype.find_or_create_by!(name: 'Dish')
dish.properties += [
  Spree::Property.find_or_create_by!(name: 'time', presentation: 'Time'),
  Spree::Property.find_or_create_by!(name: 'components', presentation: 'Components'),
  Spree::Property.find_or_create_by!(name: 'directions', presentation: 'Directions'),
  Spree::Property.find_or_create_by!(name: 'ingredients', presentation: 'Ingredients'),
  Spree::Property.find_or_create_by!(name: 'callout-1', presentation: 'Callout-1'),
  Spree::Property.find_or_create_by!(name: 'callout-2', presentation: 'Callout-2'),
  Spree::Property.find_or_create_by!(name: 'sidebar', presentation: 'Sidebar'),
]
