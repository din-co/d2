module Spree
  module ProductConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def restaurant
        taxons.non_root.restaurant.first
      end

      def chef
        taxons.non_root.chef.first
      end

      def diets
        taxons.non_root.diets
      end

      def allergens
        taxons.non_root.allergens
      end

      def pantry
        taxons.non_root.pantry
      end

      def equipment
        taxons.non_root.equipment
      end
    end
  end
end
