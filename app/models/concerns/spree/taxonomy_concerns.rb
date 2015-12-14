module Spree
  module TaxonomyConcerns
    extend ActiveSupport::Concern

    module ClassMethods
      def restaurant
        find_by!(name: 'Restaurants')
      end

      def chef
        find_by!(name: 'Chefs')
      end

      def diets
        find_by!(name: 'Diets')
      end

      def pantry
        find_by!(name: 'Pantry')
      end
    end
  end
end
