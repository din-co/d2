require 'rails_helper'

# See http://stackoverflow.com/a/20010923 for this method
#   of testing concerns

RSpec.shared_examples_for "spree address concerns" do
  before :all do
    require Rails.root.join('db/seeds')
  end

  # the class that includes the concern
  let(:model)   { described_class }
  let(:address) { FactoryGirl.build(:ship_address, zipcode: "94110", postal_code: nil) }

  describe 'factory' do
    let(:address) { FactoryGirl.build(:address) }
    it 'builds a valid address, including state and postal code' do
      expect(address).to be_valid
      expect(address.postal_code).to be_present, address.inspect
      expect(address.state).to be_present, address.inspect
    end
  end

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
          let(:zipcode) { "" }
          let(:address) { FactoryGirl.build(:ship_address, zipcode: zipcode) }

          it "returns true" do
            expect(address.send :associate_postal_code).to eql(true)
          end
        end

        context "when zipcode has the value of an existing postal_code" do
          let(:zipcode)     { postal_code.value }
          let(:postal_code) { FactoryGirl.create(:postal_code) }
          let(:address)     { FactoryGirl.build(:ship_address, zipcode: "#{zipcode}-1234") }

          it "associates the matching postal code" do
            expect(address).to be_valid
            expect(address.postal_code).to eql(Spree::PostalCode.find_by(value: address.zipcode.to_s.first(5)))
          end
        end
      end
    end
  end
end
