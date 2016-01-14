class CreateProduct
  def self.create!(name, price, desc=nil)
    product = Spree::Product.create!({
      name: name,
      price: price,
      description: desc,
      available_on: 1.day.ago,
      shipping_category: shipping_category,
    })

    # Create stock
    stock_location.move(product.stock_items.first.variant, 10, Spree::User.admin.first)

    # Add a chef Taxon
    product.classifications.create!(taxon: Spree::Taxon.chefs.random.first)

    # Add a restaurant Taxon
    product.classifications.create!(taxon: Spree::Taxon.restaurants.random.first)

    # Add 3 each diets, allergens, pantry, equipment
    [
      Spree::Taxon.diets.random.limit(3),
      Spree::Taxon.allergens.random.limit(3),
      Spree::Taxon.pantry.random.limit(3),
      Spree::Taxon.equipment.random.limit(3),
    ].flatten.each do |taxon|
      product.classifications.create!(taxon: taxon)
    end

    # Add properties
    product.product_properties.create!(value: "A tagline adds more clarity to the name of the dish.", property: Spree::Property.find_by!(name: 'tagline'))
    product.product_properties.create!(value: "23", property: Spree::Property.find_by!(name: 'time'))
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'components'))
      <li>Hodo Soy tofu</li>
      <li>shallot</li>
      <li>vegetable stock</li>
      <li>coconut milk</li>
    HTML
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'directions'))
      <li>Lorem ipsum Excepteur commodo do non ea Excepteur dolore incididunt incididunt in fugiat et qui magna aute <b>high-heat oil</b>.</li>
      <li>Thinly slice the <b>shallot</b>. Add to the saucepan and cook until translucent.</li>
      <li>Add <b>diced pumpkin</b>. Cook for 3 minutes.</li>
      <li>Lorem ipsum Do et do tempor ut deserunt consectetur Ut consequat proident laboris eu eiusmod aute voluptate dolor exercitation deserunt nostrud fugiat dolor exercitation deserunt ut id tempor.</li>
      <li>
        Remove from heat. Add 3 tablespoons of <b>water</b>.
        <em>Removing from heat decreases the chance of a flare up if the oil splatters and catches fire.</em>
      </li>
    HTML
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'ingredients'))
      Salt, fat, acid, heat, lorem ipsum, Exercitation, pariatur magna, sunt, dolore ut sed, dolore non qui,
      ex deserunt, officia Ut, velit esse, ut, ullamco Excepteur, irure id, enim Duis consectetur,
      ut ut minim Ut sint eiusmod ut aute.
    HTML
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'callout-1'))
      <h3>You got called out!</h3>
      <p>Some <b>interesting</b> content in a paragraph.<p>
    HTML
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'callout-2'))
      <h3>Calling you out again</h3>
      <p>Some <b>interesting</b> content in a paragraph.<p>
    HTML
    product.product_properties.create!(value: <<-HTML.strip_heredoc, property: Spree::Property.find_by!(name: 'sidebar'))
      <h3>Hey, it's a sidebar!</h3>
      <p>Some <b>interesting</b> content in a paragraph.<p>
      <ul>
        <li>A bulleted unordered list of things.</li>
        <li>A bulleted unordered list of things.</li>
      </ul>
      <ol>
        <li>A numbered ordered list of steps.</li>
        <li>A numbered ordered list of steps.</li>
        <li>A numbered ordered list of steps.</li>
      </ol>
    HTML

    product
  end

  def self.prototype
    Spree::Prototype.first
  end

  def self.shipping_category
    Spree::ShippingCategory.first
  end

  def self.stock_location
    Spree::StockLocation.order_default.active.first
  end
end
