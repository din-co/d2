module Spree
  module ProductConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def restaurant
        taxons.where('parent_id IS NOT NULL').find_by(taxonomy: Spree::Taxonomy.restaurant)
      end

      def chef
        taxons.where('parent_id IS NOT NULL').find_by(taxonomy: Spree::Taxonomy.chef)
      end

      def diets
        taxons.where('parent_id IS NOT NULL').where(taxonomy: Spree::Taxonomy.diets)
      end

      def pantry
        taxons.where('parent_id IS NOT NULL').where(taxonomy: Spree::Taxonomy.pantry)
      end

      def equipment
        taxons.where('parent_id IS NOT NULL').where(taxonomy: Spree::Taxonomy.equipment)
      end
    end
  end
end
