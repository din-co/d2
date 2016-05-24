require 'rails_helper'

RSpec.feature "Checkout flow:" do
  let(:product) { ProductFactory.create!("Gulf White Shrimp + Caesar + Chicories + Avocado", 30.00, allergens: %w[shellfish], desc: <<-TXT.strip_heredoc) }
    These shrimp are caught from healthy stocks using trawls that allow sea turtles to escape. By buying these shrimp, we are supporting fisheries badly damaged in Hurricane Katrina. Cooling avocado contrasts spicy harissa, a North African condiment, on a salad of bitter greens, all assertive flavors held in perfect balance.
  TXT

  def fill_in_user_registration_fields
    fill_in "Email", with: "new_user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
  end

  def fill_in_shipping_address_fields(address)
    fill_in "First Name", with: address.firstname
    fill_in "Last Name", with: address.lastname
    fill_in "Street Address", with: address.address1
    fill_in "City", with: address.city
    select address.state.name
    fill_in "Zip", with: address.zipcode
    fill_in "Phone", with: address.phone
    fill_in "Delivery Instructions", with: "Ring the doorbell and then huck the package onto the roof"
  end

  def fill_in_credit_card_payment_fields(address, number=nil)
    expect(page).to have_text("Stripe")
    using_wait_time(8) do # give Stripe more time…
      within_frame(find('.stripe_checkout_app')) do
        fill_in "billing-name", with: "#{address.firstname} #{address.lastname}"
        fill_in "billing-street", with: address.address1
        fill_in "billing-zip", with: address.zipcode
        fill_in "billing-city", with: address.city
        click_on "submitButton"

        fill_in "card_number", with: number || "4242424242424242"
        fill_in "cc-exp", with: 6.months.from_now.strftime("%-l%y") # e.g. 1217
        fill_in "cc-csc", with: "123"
        click_on "submitButton"
      end
    end
  end

  def has_order_details(order)
    order.reload
    expect(page).to have_text(order.ship_address.firstname)
    expect(page).to have_text(order.ship_address.lastname)
    expect(page).to have_text(order.ship_address.address1)
    expect(page).to have_text(order.ship_address.city)
    expect(page).to have_text(order.ship_address.state.abbr)
    expect(page).to have_text(order.ship_address.zipcode)
    expect(page).to have_text(order.ship_address.phone)
    expect(page).to have_text(order.ship_address.delivery_instructions)
    expect(page).to have_text(order.delivery_window.to_s)
    order.products.each do |product|
      expect(page).to have_text(product.name)
    end
    expect(page).to have_text(Spree.t(order.user.default_credit_card.cc_type))
    expect(page).to have_text(order.user.default_credit_card.last_digits)

    expect(order.shipment_date).to be >= order.completed_at
  end

  describe "when the kitchen is open", js: true do
    before do
      Timecop.travel(KITCHEN.opening_time)
      expect(product).to be_available
      # Home page
      visit spree.root_path
      click_on product.name

      # Product page
      expect(page).to have_current_path(spree.product_path(product))
      click_on "Add to Cart #{product.half_price}/serving × 2"

      # Cart page
      expect(page).to have_current_path(spree.cart_path)
      expect(page).to have_text(product.name)
      # TODO: check that only one is added
      click_on "Checkout"

      expect(page).to have_current_path(spree.checkout_registration_path)
      fill_in_user_registration_fields
      click_on "Create"
    end

    after do
      Timecop.return
    end

    describe "shipping to inside our delivery area" do
      let(:address) { FactoryGirl.build_stubbed(:address) }
      let(:outside_address) { FactoryGirl.build_stubbed(:address, city: "Beverly Hills", zipcode: "90210") }

      scenario "placing an order billed to a new card, using the shipping address, then placing a second order using the same card" do
        # Address entry
        expect(page).to have_current_path(spree.checkout_state_path(:address))
        fill_in_shipping_address_fields(address)
        click_on "Save and Continue"

        # Delivery options
        expect(page).to have_current_path(spree.checkout_state_path(:delivery))
        delivery_window = Spree::DeliveryWindow.available.first
        choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
        click_on "Save and Continue"

        # Payment page
        click_on "Add Card"
        fill_in_credit_card_payment_fields(address)

        # Confirm page (make time for Stripe call)
        using_wait_time(8) { expect(page).to have_current_path(spree.checkout_state_path(:confirm)) }
        order = Spree::Order.last
        has_order_details(order)
        find_button("Place Order", match: :first).click

        # Order summary page
        expect(page).to have_current_path(spree.order_path(order.number))
        expect(page).to have_text(order.number)
        has_order_details(order)

        # Order again (quicker!)
        visit spree.root_path
        click_on product.name
        click_on "Add to Cart #{product.half_price}/serving × 2"
        expect(page).to have_current_path(spree.cart_path)
        click_on "Checkout"
        expect(page).to have_current_path(spree.checkout_state_path(:address))
        # No need to fill in shipping details
        click_on "Save and Continue"
        expect(page).to have_current_path(spree.checkout_state_path(:delivery))
        delivery_window = Spree::DeliveryWindow.available.first
        choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
        click_on "Save and Continue"
        # Payment info already filled in
        click_on "Continue"
        expect(page).to have_current_path(spree.checkout_state_path(:confirm))
        order = Spree::Order.last
        has_order_details(order)
        find_button("Place Order", match: :first).click
        expect(page).to have_current_path(spree.order_path(order.number))
        expect(page).to have_text(order.number)
        has_order_details(order)
      end

      scenario "placing an order billed to an address outside our delivery area" do
        # Address entry
        expect(page).to have_current_path(spree.checkout_state_path(:address))
        fill_in_shipping_address_fields(address)
        click_on "Save and Continue"

        # Delivery options
        expect(page).to have_current_path(spree.checkout_state_path(:delivery))
        delivery_window = Spree::DeliveryWindow.available.first
        choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
        click_on "Save and Continue"

        # Payment page
        click_on "Add Card"
        fill_in_credit_card_payment_fields(outside_address)

        # Confirm page (make time for Stripe call)
        using_wait_time(8) { expect(page).to have_current_path(spree.checkout_state_path(:confirm)) }
        order = Spree::Order.last
        has_order_details(order)
        find_button("Place Order", match: :first).click

        # Order summary page
        expect(page).to have_current_path(spree.order_path(order.number))
        expect(page).to have_text(order.number)
        has_order_details(order)
      end

      scenario "going back through the checkout process after entering a different credit card preserves the newer card" do
        # Start with a card
        visit spree.account_cards_path
        click_on "Add Card"
        fill_in_credit_card_payment_fields(address, "4111111111111111")
        using_wait_time(8) { expect(page).to have_current_path(spree.account_path) }

        visit spree.cart_path
        click_on "Checkout"
        fill_in_shipping_address_fields(address)
        click_on "Save and Continue"

        delivery_window = Spree::DeliveryWindow.available.first
        choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
        click_on "Save and Continue"

        # Enter a different card during checkout
        click_on "Change Card"
        fill_in_credit_card_payment_fields(address, "4242424242424242")
        using_wait_time(8) { click_on "Continue" }
        has_order_details(Spree::Order.last)

        visit spree.cart_path
        click_on "Checkout" # cart
        click_on "Save and Continue" # address
        click_on "Save and Continue" # delivery window

        expect(page).to     have_text("4242")
        expect(page).not_to have_text("1111")
      end
    end
  end
end
