require 'rails_helper'

# See http://stackoverflow.com/a/20010923 for this method
#   of testing concerns

RSpec.shared_examples_for "spree address concerns" do
  # the class that includes the concern
  let(:model)   { described_class }
  let(:address) { FactoryGirl.build(:ship_address, zipcode: "94110", postal_code: nil) }

  describe "callbacks" do
    it "associates a postal code during validation" do
      expect(address.zipcode).to_not be_nil
      expect(address.postal_code).to be_nil
      expect(address).to be_valid
      expect(address.postal_code).to eql(Spree::PostalCode.find_by(value: address.zipcode))
    end

  end

  describe "private methods" do
    describe "associate_postal_code" do
      context "when country is US" do
        context "zipcode is blank" do
          let(:address) { FactoryGirl.build(:ship_address, zipcode: "", postal_code: nil) }

          it "returns true" do
            expect(address.send :associate_postal_code).to eql(true)
          end
        end

        context "when zipcode has the value of an existing postal_code" do
          let(:postal_code) { FactoryGirl.create(:postal_code) }
          let(:address)     { FactoryGirl.build(:ship_address, zipcode: "#{postal_code.value}-1234", postal_code: nil) }

          it "associates the matching postal code" do
            expect(address).to be_valid
            expect(address.postal_code).to eql(Spree::PostalCode.find_by(value: address.zipcode.to_s.first(5)))
          end
        end
      end
    end
  end
end
