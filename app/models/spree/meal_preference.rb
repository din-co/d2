module Spree
  class MealPreference < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validate :vegetarian_and_no_soy
    validate :allergens_and_no_allergen

  private

    def vegetarian_and_no_soy
      if allergen_soybeans && (diet_tofu || diet_tempeh)
        errors.add(:base, "If you don’t eat soybeans, then you probably shouldn’t select tofu or tempeh.")
      end
    end

    def allergens_and_no_allergen
      unless allergen_none ^ (allergen_eggs || allergen_fish || allergen_milk || allergen_peanuts || allergen_shellfish || allergen_soybeans || allergen_tree_nuts || allergen_wheat_gluten)
        errors.add(:base, 'Please select "none" or specific allergens, not both.')
      end
    end

  end
end
