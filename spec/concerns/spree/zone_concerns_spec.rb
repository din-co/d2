require 'rails_helper'

# See http://stackoverflow.com/a/20010923 for this method
#   of testing concerns

RSpec.shared_examples_for "spree zone concerns" do
  # the class that includes the concern
  let(:model) { described_class }

  describe "class methods" do
    describe "match" do
      pending "it matches a zone based on postal code type as highest priority"
    end
  end

  describe "instance methods" do
    describe "include?" do
      context "with address having postal code in postal code zone" do
        pending "it returns true"
      end
    end

    describe "country_list" do
      context "with zone having many postal code members" do
        pending "it returns the countries containing the postal code members"
      end
    end

    describe "postal_code_ids" do
      pending "it returns zone member ids with kind of 'postal_code'"
    end

    describe "postal_code_ids=" do
      pending "it creates zone members of kind 'postal_code' with passed zoneable ids"
    end

    describe "contains?" do
      pending "test the crap out of this one, nine permutations"
    end
  end
end
