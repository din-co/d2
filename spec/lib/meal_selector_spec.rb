require 'rails_helper'
require 'support/subscription_data'

RSpec.describe MealSelector, subscription_data: true do
  let(:meals) { [braised_veg, breakfast_sandwich, sauteed_fish, tofu_fried_rice] }
  let(:meal_preferences) { meal_preferences_in_order.shuffle }
  let(:meal_preferences_in_order) {[
    highly_restricted_mp,
    many_allergies_mp,
    strict_diet_mp,
    pescatarian_mp,
    no_beef_pork_shellfish_mp,
    no_pork_fish_mp,
    no_shellfish_mp,
    default_mp,
  ]}

  let(:meal_selector) { described_class.new(meal_preferences) }

  it 'orders meal preferences from most to least constrained' do
    # Verify preconditions
    expect(meal_preferences).not_to eql meal_preferences_in_order
    expect(meal_preferences).to match_array meal_preferences_in_order

    expect(meal_selector.meal_preferences).to eql meal_preferences_in_order
  end

  describe 'with subscriptions' do
    let(:subscriptions) { meal_preferences_in_order.map { |mp| FactoryGirl.create(:meal_subscription, user: mp.user) } }
    let(:available_meals) {
      n = meal_preferences.size
      {
        breakfast_sandwich => n,
        sauteed_fish => n,
        tofu_fried_rice => n,
        braised_veg => n,
      }
    }
    let(:meal_selector) { described_class.new(meal_preferences, subscriptions, available_meals) }

    it "returns selections matching the subscribers' meal preferences" do
      expect(meal_selector.selections[subscriptions[0]]).to eql([braised_veg, nil])
      expect(meal_selector.selections[subscriptions[1]]).to eql([braised_veg, nil])
      expect(meal_selector.selections[subscriptions[2]]).to eql([braised_veg, nil])
      expect(meal_selector.selections[subscriptions[3]]).to eql([sauteed_fish, tofu_fried_rice])
      expect(meal_selector.selections[subscriptions[4]]).to eql([sauteed_fish, tofu_fried_rice])
      expect(meal_selector.selections[subscriptions[5]]).to eql([tofu_fried_rice, braised_veg])
      expect(meal_selector.selections[subscriptions[6]]).to eql([breakfast_sandwich, sauteed_fish])
      expect(meal_selector.selections[subscriptions[7]]).to eql([breakfast_sandwich, sauteed_fish])
    end

    describe 'and restricted stock' do
      let(:available_meals) { {
          braised_veg => 3,
          sauteed_fish => 3,
          breakfast_sandwich => 1,
          tofu_fried_rice => 1,
      } }

      it "returns selections matching the subscribers' meal preferences" do
        expect(meal_selector.selections[subscriptions[0]]).to eql([braised_veg, nil])
        expect(meal_selector.selections[subscriptions[1]]).to eql([braised_veg, nil])
        expect(meal_selector.selections[subscriptions[2]]).to eql([braised_veg, nil])
        expect(meal_selector.selections[subscriptions[3]]).to eql([sauteed_fish, tofu_fried_rice])
        expect(meal_selector.selections[subscriptions[4]]).to eql([sauteed_fish, nil])
        expect(meal_selector.selections[subscriptions[5]]).to eql([nil, nil])
        expect(meal_selector.selections[subscriptions[6]]).to eql([sauteed_fish, breakfast_sandwich])
        expect(meal_selector.selections[subscriptions[7]]).to eql([nil, nil])
      end
    end
  end
end