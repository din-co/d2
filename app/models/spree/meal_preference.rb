module Spree
  class Spree::MealPreference < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validate :allergens_and_no_allergen

  private

    def allergens_and_no_allergen
      unless allergen_none ^ (allergen_eggs || allergen_fish || allergen_milk || allergen_peanuts || allergen_shellfish || allergen_soybeans || allergen_tree_nuts || allergen_wheat_gluten)
        errors.add(:base, "Specify specific allergens or No allergens, not both")
      end
    end

  end
end
