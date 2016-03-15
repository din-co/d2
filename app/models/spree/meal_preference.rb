module Spree
  class MealPreference < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new

    validate :vegetarian_and_no_soy

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
      if allergen_soybeans && (diet_tofu || diet_tempeh)
        errors.add(:base, "If you don’t eat soybeans, then you probably shouldn’t select tofu or tempeh.")
      end
    end
  end
end
