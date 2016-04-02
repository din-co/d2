require 'rails_helper'
require 'support/subscription_data'

RSpec.describe Spree::MealPreference, type: :model, subscription_data: true do
  describe 'highly restricted' do
    subject { highly_restricted_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to_not be_allowed sauteed_fish }
    it { is_expected.to_not be_allowed tofu_fried_rice }
  end

  describe 'many allergies' do
    subject { many_allergies_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to_not be_allowed sauteed_fish }
    it { is_expected.to_not be_allowed tofu_fried_rice }
  end

  describe 'strict diet' do
    subject { strict_diet_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to_not be_allowed sauteed_fish }
    it { is_expected.to_not be_allowed tofu_fried_rice }
  end

  describe 'pescatarian' do
    subject { pescatarian_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to     be_allowed sauteed_fish }
    it { is_expected.to     be_allowed tofu_fried_rice }
  end

  describe 'no beef, pork, or shellfish' do
    subject { no_beef_pork_shellfish_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to     be_allowed sauteed_fish }
    it { is_expected.to     be_allowed tofu_fried_rice }
  end

  describe 'no pork or shellfish' do
    subject { no_pork_fish_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to_not be_allowed breakfast_sandwich }
    it { is_expected.to_not be_allowed sauteed_fish }
    it { is_expected.to     be_allowed tofu_fried_rice }
  end

  describe 'no shellfish' do
    subject { no_shellfish_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to     be_allowed breakfast_sandwich }
    it { is_expected.to     be_allowed sauteed_fish }
    it { is_expected.to     be_allowed tofu_fried_rice }
  end

  describe 'default' do
    subject { default_mp }
    it { is_expected.to     be_allowed braised_veg }
    it { is_expected.to     be_allowed breakfast_sandwich }
    it { is_expected.to     be_allowed sauteed_fish }
    it { is_expected.to     be_allowed tofu_fried_rice }
  end
end
