FactoryGirl.define do
  factory :meal_preference, class: Spree::MealPreference do
    user

    trait :soy_allergy do
      allergen_soybeans true
      diet_tofu false
    end
    trait :shellfish_allergy do
      allergen_shellfish true
      diet_seafood false
    end
    trait :fish_allergy do
      allergen_fish true
      diet_fish false
    end

    trait :nut_allergy do
      allergen_peanuts true
      allergen_tree_nuts true
    end

    trait :many_allergies do
      allergen_milk true
      allergen_wheat_gluten true
      fish_allergy
      shellfish_allergy
    end

    trait :pescatarian do
      diet_beef false
      diet_lamb false
      diet_pork false
      diet_poultry false
      diet_rabbit false
    end

    trait :no_meats do
      pescatarian
      diet_fish false
      diet_seafood false
    end

    factory :highly_restricted_diet, traits: [:no_meats, :soy_allergy] do
      allergen_milk true
      allergen_wheat_gluten true
    end
    factory :strict_diet, traits: [:no_meats] do
      allergen_wheat_gluten true
    end
    factory :many_allergies, traits: [:many_allergies, :nut_allergy, :soy_allergy]
  end
end
