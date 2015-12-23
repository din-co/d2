require 'rails_helper'

RSpec.describe Spree::PostalCode, type: :model do
  describe "associations" do
    pending "it belongs to a state"
    pending "it belongs to a country"
    pending "it has many addresses"
  end

  describe "validations" do
    pending "value is required"
    pending "country is required"
    pending "runs postal_code_validate"
    pending "runs us_restrict_digits_validate"
  end

  describe "instance methods" do
    pending "#<=> compares by value"
    pending "#to_s returns value"

    describe "private methods" do
      describe "postal_code_validate" do
        pending "it validates the postal code for the country"
      end

      describe "us_restrict_digits_validate" do
        pending "it restricts digits to five for the USA"
      end
    end
  end
end
