RSpec.shared_context "meal preferences and meals", subscription_data: true do
  before(:all) do
    require Rails.root.join('db/seeds')
  end

  let(:braised_veg)        { ProductFactory.create!("Braised vegetables", 30, allergens: [], proteins: []) }
  let(:breakfast_sandwich) { ProductFactory.create!("Sausage breakfast sandwich", 25, allergens: %w[eggs wheat/gluten], proteins: %w[pork]) }
  let(:sauteed_fish)       { ProductFactory.create!("Sautéed fish", 34, allergens: %w[fish], proteins: %w[fish]) }
  let(:tofu_fried_rice)    { ProductFactory.create!("Tofu fried rice", 29.99, allergens: %w[soybeans wheat/gluten], proteins: %w[tofu]) }

  let(:highly_restricted_mp)      { FactoryGirl.create(:highly_restricted_diet) }
  let(:many_allergies_mp)         { FactoryGirl.create(:many_allergies) }
  let(:strict_diet_mp)            { FactoryGirl.create(:strict_diet) }
  let(:pescatarian_mp)            { FactoryGirl.create(:meal_preference, :pescatarian) }
  let(:no_beef_pork_shellfish_mp) { FactoryGirl.create(:meal_preference, :shellfish_allergy, diet_pork: false, diet_beef: false) }
  let(:no_pork_shellfish_mp)      { FactoryGirl.create(:meal_preference, :shellfish_allergy, diet_pork: false) }
  let(:no_shellfish_mp)           { FactoryGirl.create(:meal_preference, :shellfish_allergy) }
  let(:default_mp)                { FactoryGirl.create(:meal_preference) }
end
