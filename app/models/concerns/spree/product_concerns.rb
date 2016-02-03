module Spree
  module ProductConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def restaurant
        taxons.restaurants.first
      end

      def chef
        taxons.chefs.first
      end

      def diets
        taxons.diets
      end

      def allergens
        taxons.allergens
      end

      def pantry
        taxons.pantry
      end

      def equipment
        taxons.equipment
      end

      def pages
        taxons.pages
      end

      def on_home_page?
        pages.find_by(name: "Home").present?
      end
    end
  end
end
