module Spree
  class MealPreference < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validate :vegetarian_and_no_soy
    validate :so_long_thanks_for_all_the_fish
    validate :seafood_and_shellfish

    def self.diets
      attribute_names.select { |name| name.start_with?("diet_") }
    end

    def self.diet_names
      diets.map { |attr_name| diet_name(attr_name) }
    end

    def self.diet_name(diet)
      diet.to_s.sub(/^diet_/, '')
    end

    def self.allergens
      attribute_names.select { |name| name.start_with?("allergen_") }
    end

    def self.allergen_names
      allergens.map { |attr_name| allergen_name(attr_name) }
    end

    def self.allergen_name(allergen)
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

    delegate :diet_name, :allergen_name, to: :class

    def diets
      attributes.select { |name, value| value && name.start_with?("diet_") }.keys
    end

    def diet_names
      diets.map { |d| diet_name(d) }
    end

    def display_diet_names
      (diet_names << "vegetables").to_sentence
    end

    def diet_count
      diets.size
    end

    def allergens
      attributes.select { |name, value| value && name.start_with?("allergen_") }.keys
    end

    def allergen_names
      allergens.map { |d| allergen_name(d) }
    end

    def allergen_count
      allergens.size
    end

    def allergen_none
      allergens.blank?
    end

    # Determines if a meal preference permits a meal to be included as a selection.
    def allowed?(meal)
      conflicting_allergens = meal.contains_allergens(allergen_names)
      return false if conflicting_allergens.present?

      proteins_present = meal.proteins.pluck(:name)
      conflicting_proteins = proteins_present - diet_names

      conflicting_proteins.blank?
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
