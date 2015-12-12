module Spree
  module ProductConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def restaurant
        taxons.find_by!(taxonomy: Spree::Taxonomy.restaurant)
      end

      def chef
        taxons.find_by!(taxonomy: Spree::Taxonomy.chef)
      end

      def diets
        taxons.where(taxonomy: Spree::Taxonomy.diets)
      end

      def pantry
        taxons.where(taxonomy: Spree::Taxonomy.pantry)
      end
    end
  end
end
