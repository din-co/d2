module Spree
  class MealPreference < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validate :vegetarian_and_no_soy
    validate :so_long_thanks_for_all_the_fish
    validate :seafood_and_shellfish

    def allergen_none
      self.class.allergens.none? { |allergen| send(allergen) }
    end

    def diet_name(diet)
      diet.to_s.sub(/^diet_/, '')
    end

    def allergen_name(allergen)
      allergen = allergen.to_s
      case allergen
      when "allergen_wheat_gluten"
        "wheat/gluten"
      when "allergen_tree_nuts"
        "tree nuts"
      else
        allergen.sub(/^allergen_/, '')
      end
    end

    def self.diets
      attribute_names.select { |name| name.start_with?("diet_") }.map(&:to_sym)
    end

    def self.allergens
      attribute_names.select { |name| name.start_with?("allergen_") }.map(&:to_sym)
    end

  private

    def vegetarian_and_no_soy
      if allergen_soybeans && (diet_tofu)
        errors.add(:base, "If you don’t eat soybeans, then you probably shouldn’t select tofu.")
      end
    end

    def so_long_thanks_for_all_the_fish
      if diet_fish && allergen_fish
        errors.add(:base, "Hmmm… If you’re allergic to fish, but you eat fish anyway… you’re loco amigo.")
      end
    end

    def seafood_and_shellfish
      if diet_seafood && allergen_shellfish
        errors.add(:base, 'If you’re allergic to shellfish, but you eat seafood, please select "fish" instead of "seafood".')
      end
    end
  end
end
