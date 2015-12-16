require 'rails_helper'

# See http://stackoverflow.com/a/20010923 for this method
#   of testing concerns

shared_examples_for "spree address concerns" do
  # the class that includes the concern
  let(:model) { described_class }

  describe "associations" do
    pending "belongs_to postal_code"
  end

  describe "callbacks" do
    pending "it runs associate_postal_code after validation if valid"
    pending "it does not run associate_postal_code if not valid"
  end

  describe "private methods" do
    describe "associate_postal_code" do
      context "postal code is blank" do
        pending "it returns true"
      end

      context "postal code is not blank" do
        context "when country is US" do
          pending "it associates a postal code object with first 5 digits of zipcode"
        end

        context "when country is not US" do
          pending "it associates a postal code object with the entire value of zipcode"
        end
      end
    end
  end
end
