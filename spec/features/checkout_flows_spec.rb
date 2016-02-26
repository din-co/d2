require 'rails_helper'

RSpec.feature "Checkout flow:" do
  let(:address) { FactoryGirl.build_stubbed(:address) }
  let(:product) { CreateProduct.create!("Gulf White Shrimp + Caesar + Chicories + Avocado", 30.00, <<-TXT.strip_heredoc) }
    These shrimp are caught from healthy stocks using trawls that allow sea turtles to escape. By buying these shrimp, we are supporting fisheries badly damaged in Hurricane Katrina. Cooling avocado contrasts spicy harissa, a North African condiment, on a salad of bitter greens, all assertive flavors held in perfect balance.
  TXT

  def fill_in_user_registration_fields
    fill_in "Email", with: "new_user@example.com"
    fill_in "Password", with: "password"
    fill_in "Confirm Password", with: "password"
  end

  def fill_in_credit_card_payment_fields
    expect(page).to have_current_path(spree.checkout_state_path(:payment))
    expect(page).to have_text("Stripe")
    within("#payment-methods") do
      fill_in "Name on card", with: "#{address.firstname} #{address.lastname}"
      # TODO: make this use stripe.js!!
      fill_in "Card Number", with: "4242424242424242"
      fill_in "Expiration", with: 6.months.from_now.strftime("%-l/%y") # e.g. 12/17
      fill_in "CVC", with: "123"
    end
  end

  describe "when the kitchen is open" do
    before do
      Timecop.travel(KITCHEN.opening_time)
      expect(product).to be_available
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

      expect(page).to have_current_path(spree.checkout_registration_path)
      fill_in_user_registration_fields
      click_on "Create"
    end

    after do
      Timecop.return
    end

    scenario "a customer orders a product for delivery to their billing address", js: true do
      # Address entry
      expect(page).to have_current_path(spree.checkout_state_path(:address))
      address.zipcode = "94110"
      within("#billing") do
        fill_in "First Name", with: address.firstname
        fill_in "Last Name", with: address.lastname
        fill_in "Street Address", with: address.address1
        fill_in "City", with: address.city
        select address.state.name
        fill_in "Zip", with: address.zipcode
        fill_in "Phone", with: address.phone
      end
      within("#shipping") do
        check "Same as billing address"
      end
      click_on "Save and Continue"

      # Delivery options
      expect(page).to have_current_path(spree.checkout_state_path(:delivery))
      delivery_window = Spree::DeliveryWindow.available.first
      choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
      fill_in "Delivery Instructions", with: "Ring the doorbell and then huck the package onto the roof"
      click_on "Save and Continue"

      # Payment page -> Order confirmation page
      fill_in_credit_card_payment_fields
      click_on "Save and Continue"
      using_wait_time(5) do # give Stripe more time...
        expect(page).to have_current_path(spree.checkout_state_path(:confirm))
      end
      expect(page).to have_text(product.name)
      # TODO: verify that important information is present
      click_on "Place Order"

      # Order summary page
      user = Spree::User.last
      expect(page).to have_current_path(spree.order_path(user.orders.first.number))
      # TODO: verify that important information is present
      expect(page).to have_text(product.name)
    end

    scenario "a customer orders a product for delivery with a billing address outside, but a shipping address inside the service area", js: true do
      # Address entry
      expect(page).to have_current_path(spree.checkout_state_path(:address))
      within("#billing") do
        fill_in "First Name", with: address.firstname
        fill_in "Last Name", with: address.lastname
        fill_in "Street Address", with: address.address1
        fill_in "City", with: "Beverly Hills"
        select address.state.name
        fill_in "Zip", with: "90210"
        fill_in "Phone", with: address.phone
      end
      within("#shipping") do
        uncheck "Same as billing address"
        fill_in "First Name", with: address.firstname
        fill_in "Last Name", with: address.lastname
        fill_in "Street Address", with: address.address1
        fill_in "City", with: address.city
        select address.state.name
        fill_in "Zip", with: address.zipcode
        fill_in "Phone", with: address.phone
      end
      click_on "Save and Continue"

      # Delivery options
      expect(page).to have_current_path(spree.checkout_state_path(:delivery))
      delivery_window = Spree::DeliveryWindow.available.first
      choose("#{delivery_window.to_s} #{delivery_window.display_cost}")
      fill_in "Delivery Instructions", with: "Ring the doorbell and then huck the package onto the roof"
      click_on "Save and Continue"

      # Payment page -> Order confirmation page
      fill_in_credit_card_payment_fields
      click_on "Save and Continue"
      using_wait_time(5) do # give Stripe more time...
        expect(page).to have_current_path(spree.checkout_state_path(:confirm))
      end
      expect(page).to have_text(product.name)
      # TODO: verify that important information is present
      click_on "Place Order"

      # Order summary page
      user = Spree::User.last
      expect(page).to have_current_path(spree.order_path(user.orders.first.number))
      # TODO: verify that important information is present
      expect(page).to have_text(product.name)
    end
  end
end
