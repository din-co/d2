require 'rails_helper'

RSpec.describe Spree::PostalCode, type: :model do
  let(:postal_code) { FactoryGirl.build(:postal_code) }

  describe "validations" do
    it "requires a value" do
      expect(postal_code.value).to be_present
      expect(postal_code).to be_valid
      postal_code.value = ""
      expect(postal_code.errors[:value]).to be_present
    end

    it "requires a country_id" do
      expect(postal_code.country_id).to be_present
      expect(postal_code).to be_valid
      postal_code.country_id = ""
      expect(postal_code.errors[:country_id]).to be_present
    end

    it "runs postal_code_validate" do
      expect(postal_code).to be_valid
      postal_code.value = "Q3X 4F3"
      expect(postal_code.errors).to be_present
    end

    it "restricts US postal codes to 5 digits" do
      postal_code.value = "94110-1234"
      expect(postal_code).to_not be_valid
      expect(postal_code.errors[:value]).to include(I18n.t("activerecord.attributes.errors.models.spree/postal_codes.attributes.zipcode.numericality"))
    end
  end

  describe "instance methods" do
    it "#<=> compares by value"
    it "#to_s returns value"

    describe "private methods" do
      describe "postal_code_validate" do
        it "it validates the postal code for the country"
      end

      describe "us_restrict_digits_validate" do
        it "it restricts digits to five for the USA"
      end
    end
  end
end
