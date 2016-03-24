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

CreateProduct.create!("Mushroom Risotto", 29.99, allergens: %w[eggs wheat], desc: "Risotto from scratch is a slow process. So, how does a restaurant fire risotto so quickly? A ready-made base knocks out the first several steps of stirring. You’ll do the last steps to finish it off. Reverb uses carnaroli rice, known as the “king of Italian rices.” You’re probably more familiar with arborio rice for risotto, but with a higher starch content in carnaroli rice, you get an even more creamy bite. This velvety bowl is topped with a slow cooked egg, paprika oil for a kick, and finished with big crispy kale chips.")
CreateProduct.create!("Duck Breast a l’Orange", 44.50, desc: "Duck and cover it (with a mandarin gel), straight from Reverb’s kitchen. Duck à l’Orange is a classic French dish where duck is served with an orange sauce. Reverb’s version with in-season citrus of mandarin and kumquats will teach you the skills for a little caramelization of fresh citrus on the stovetop. The duck breast is served over rutabaga two ways: a rutabaga “steak” and smear of rutabaga puree. All served up with a winter green salad. Duck, duck, delicious.")
CreateProduct.create!("Kale Salad with Achiote Chicken", 30.00, allergens: %w[milk], desc: "Oh the T-lish Kale Salad, the dish that started it all for us. In the earliest days of Din, our founders Em & Rob were on the hunt to make it easier to cook delicious dishes on the busiest nights of the week. While experimenting with an idea and many recipes, Em just so happened to share the recipe she had put together to recreate the Tacolicious Kale Salad, and everyone went nuts for it. Restaurant-quality meals, cooked at home? Yes, please. Though, it turned out to actually cook like a restaurant, it takes hours of prep and overnight steps. Ain’t nobody got time for that. Then it hit us, every restaurant can fire a dish in 20 min, it simply takes a good sous chef to prep the mise en place (that’s restaurant lingo for “everything it’s place” aka the prepped ingredients). So here it is, the salad that started it all. It’s hearty with chunks of apple and butternut squash, gets a zip from the cumin vinaigrette, and some good healthy protein with a toss of quinoa, toasted pepitas and almonds. We made it dinner-worthy by adding our own Achiote marinated chicken. Dig in.")
