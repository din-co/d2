require 'rails_helper'

RSpec.feature "Checkout flow:" do
  let(:address) { FactoryGirl.build_stubbed(:address, state: Spree::State.find_by!(name: "California")) }
  let(:product) { CreateProduct.create!("Gulf White Shrimp + Caesar + Chicories + Avocado", 30.00, <<-TXT.strip_heredoc) }
    These shrimp are caught from healthy stocks using trawls that allow sea turtles to escape. By buying these shrimp, we are supporting fisheries badly damaged in Hurricane Katrina. Cooling avocado contrasts spicy harissa, a North African condiment, on a salad of bitter greens, all assertive flavors held in perfect balance.
  TXT

  after do
    Timecop.return
  end

  context 'when the kitchen is closed' do
    before do
      Timecop.travel(KITCHEN.closing_time)
    end

    scenario
  end

  context 'when the kitchen is open' do
    before do
      Timecop.travel(KITCHEN.opening_time)
      expect(product).to be_available
    end

    scenario "visitor orders a dish for delivery today", js: true do
      # Home page
      visit spree.root_path
      click_on product.name

      # Product page
      expect(page).to have_current_path(spree.product_path(product))
      click_on "Add to Cart (Serves 2) #{product.display_price}"

      # Cart page
      expect(page).to have_current_path(spree.cart_path)
      expect(page).to have_text(product.name)
      # TODO: check that only one is added
      click_on "Checkout"

      # User registration pages
      expect(page).to have_current_path(spree.checkout_registration_path)
      fill_in "Email", with: "new_user@example.com"
      fill_in "Password", with: "password"
      fill_in "Confirm Password", with: "password"
      click_on "Create"
      user = Spree::User.last

      # Address page
      expect(page).to have_current_path(spree.checkout_state_path(:address))
      address.zipcode = "94110"
      within("#billing") do
        fill_in "First Name", with: address.firstname
        fill_in "Last Name", with: address.lastname
        fill_in "Street Address", with: address.address1
        fill_in "City", with: address.city
        select "California"
        fill_in "Zip", with: address.zipcode
        fill_in "Phone", with: address.phone
      end
      within("#shipping") do
        check "Same as billing address"
      end
      click_on "Save and Continue"

      # Delivery options page
      expect(page).to have_current_path(spree.checkout_state_path(:delivery))
      delivery_window = Spree::DeliveryWindow.available.first
      choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
      fill_in "Delivery Instructions", with: "Ring the doorbell and then huck the package onto the roof"
      click_on "Save and Continue"

      # Payment information page
      expect(page).to have_current_path(spree.checkout_state_path(:payment))
      expect(page).to have_text("Stripe")
      within("#payment-methods") do
        fill_in "Name on card", with: "#{address.firstname} #{address.lastname}"
        # TODO: make this use stripe.js!!
        fill_in "Card Number", with: "4242424242424242"
        fill_in "Expiration", with: 6.months.from_now.strftime("%-l/%y") # e.g. 12/17
        fill_in "CVC", with: "123"
      end

        click_on "Save and Continue"

      # Confirmation page
      using_wait_time(5) do # give Stripe more time...
        expect(page).to have_current_path(spree.checkout_state_path(:confirm))
      end
      expect(page).to have_text(product.name)
      # TODO: veriy that important information is present
      click_on "Place Order"

      # Order summary page
      expect(page).to have_current_path(spree.order_path(user.orders.first.number))
      # TODO: veriy that important information is present
      expect(page).to have_text(product.name)
    end
  end
end
