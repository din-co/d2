taxonomy_restaurants = Spree::Taxonomy.restaurant
taxonomy_chefs = Spree::Taxonomy.chef

taxon_restaurants = taxonomy_restaurants.root
taxon_chefs = taxonomy_chefs.root

Spree::Taxon.find_or_create_by!(name: "Pim Techamuanvivit", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Pim Techamuanvivit bio here."
end
Spree::Taxon.find_or_create_by!(name: "Charles Billies", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Charles Billies bio here."
end
Spree::Taxon.find_or_create_by!(name: "Telmo Faria", parent_id: taxon_chefs.id, taxonomy_id: taxonomy_chefs.id) do |t|
  t.description =  "Telmo Faria bio here."
end

Spree::Taxon.find_or_create_by!(name: "Kin Khao", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Kin Khao restaurant description here."
end
Spree::Taxon.find_or_create_by!(name: "Souvla", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Souvla restaurant description here."
end
Spree::Taxon.find_or_create_by!(name: "Uma Casa", parent_id: taxon_restaurants.id, taxonomy_id: taxonomy_restaurants.id) do |t|
  t.description = "Uma Casa restaurant description here."
end

CreateProduct.create!("Magic Beans", 14.99, "Plant these beans and your beanstalk will grow to the clouds!")
CreateProduct.create!("Zuni Roasted Chicken", 34.99, "The most amazing roasted chicken you've ever eaten, sitting on a bed of bread salad.")

