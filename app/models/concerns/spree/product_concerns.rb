module Spree
  module ProductConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      delegate :restaurants, :chefs, :diets, :allergens, :proteins, :pantry, :equipment, :pages, to: :taxons

      def restaurant
        restaurants.first
      end

      def chef
        chefs.first
      end

      def on_home_page?
        pages.find_by(name: "Home").present?
      end

      def contains_allergens(allergen_names)
        allergens.where(name: allergen_names).pluck(:name)
      end

      def contains_proteins(protein_names)
        proteins.where(name: protein_names).pluck(:name)
      end
    end
  end
end
