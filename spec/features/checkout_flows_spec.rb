require 'rails_helper'

# TODO: Spree requires a bunch of data to complete checkout, so we need to load it.
# This doesn't work:
# load "#{Rails.root}/db/seeds.rb"

RSpec.feature "Checkout flow:" do
  let(:zone) { FactoryGirl.create(:zone) }
  let(:country) { FactoryGirl.create(:country) }
  let(:state) { FactoryGirl.create(:state, :country => country) }
  let(:address) { FactoryGirl.build_stubbed(:address, state: state) }

  before do
    zone.members << Spree::ZoneMember.create(:zoneable => country)

    # A shipping method must exist for rates to be displayed on checkout page
    FactoryGirl.create(:shipping_method, zones: [zone]).tap do |sm|
      sm.calculator.preferred_amount = 10
      sm.calculator.preferred_currency = Spree::Config[:currency]
      sm.calculator.save
    end

    Spree::StockLocation.create!(name: 'Default', default: true, country: country)
    product = CreateProduct.create!("Magic Beans", 5.99, "A descripton of some special beans")
  end

  scenario "visitor orders a dish for delivery today" do
    # Home page
    visit root_path
    click_on product.name

    # Product page
    expect(page).to have_current_path(cart_path)
    click_on "Add To Cart"

    # Cart page
    expect(page).to have_current_path(cart_path)
    expect(page).to have_text(product.name)
    # TODO: check that only one is added
    click_on "Checkout"

    # User registration pages
    expect(page).to have_current_path(checkout_registration_path)
    click_on "Create a new account"
    expect(page).to have_current_path(signup_path)
    fill_in "Email", with: "new_user@example.com"
    fill_in "Password", with: "password"
    fill_in "Password Confirmation", with: "password"
    click_on "Create"
    user = Spree::User.last

    # Address page
    expect(page).to have_current_path(checkout_state_path(:address))
    address.zipcode = "94110"
    within_fieldset("billing") do
      fill_in "First Name", with: address.firstname
      fill_in "Last Name", with: address.lastname
      fill_in "Street Address", with: address.street1
      fill_in "City", with: address.city
      select address.country.name, from: "Country"
      select address.state.name, from: "State"
      fill_in "Zip", with: address.zipcode
      fill_in "Phone", with: address.phone
    end
    within_fieldset("shipping") do
      check "Use Billing Address"
    end
    check "Save my address"
    click_on "Save and Continue"

    # Delivery options page
    expect(page).to have_current_path(checkout_state_path(:delivery))
    expect(page).to have_text(product.name)
    find(".shipping_method input").choose # chosoe first radio option
    click_on "Save and Continue"

    # Payment information page
    expect(page).to have_current_path(checkout_state_path(:payment))
    # TODO: make this use stripe.js and run with javascript enabled (slow, but necessary)
    fill_in "Card Number", with: "4242424242424242"
    fill_in "Expiration", with: 1.year.from_now.strftime("%m%y") # e.g. 0117
    fill_in "Card Code", with: "123"
    click_on "Save and Continue"

    # Confirmation page
    expect(page).to have_current_path(checkout_state_path(:confirm))
    # TODO: veriy that important information is present
    expect(page).to have_text(product.name)
    click_on "Place Order"

    # Order summary page
    expect(page).to have_current_path(order_path(user.order_ids.first))
    # TODO: veriy that important information is present
    expect(page).to have_text(product.name)
  end

  pending "add some scenarios (or delete) #{__FILE__}"
end
