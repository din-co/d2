require 'rails_helper'

# See http://stackoverflow.com/a/20010923 for this method
#   of testing concerns

RSpec.shared_examples_for "spree address concerns" do
  # the class that includes the concern
  let(:model) { described_class }
  let(:address) { FactoryGirl.build(:ship_address, postal_code: nil) }

  describe "callbacks" do
    it "associates a postal code before validation" do
      expect(address.zipcode).to_not be_nil
      expect(address.postal_code).to be_nil
      expect(address).to be_valid
      expect(address.zipcode).to be_nil
      expect(address.postal_code).to eql(Spree::PostalCode.find_by(value: address.zipcode))
    end

  end

  describe "validations when used for shipping" do
    it 'requires all fields'
  end

  describe "validations when not used for shipping" do

    let(:address) { FactoryGirl.build(:bill_address) }

    it 'requires minimal fields'
  end

  describe "private methods" do
    describe "associate_postal_code" do
      context "zipcode is blank" do
        let(:address) { FactoryGirl.build(:ship_address, zipcode: "") }

        it "returns true" do
          expect(address.send :associate_postal_code).to eql(true)
        end
      end

      context "zipcode is not blank" do

        let(:address) { FactoryGirl.build(:ship_address, zipcode: "99999-1234") }

        context "when country is US" do
          it "associates a postal code object with first 5 digits of zipcode" do
            expect(address).to be_valid
            expect(address.postal_code).to eql(Spree::PostalCode.find_by(value: "99999"))
          end
        end
      end
    end
  end
end
