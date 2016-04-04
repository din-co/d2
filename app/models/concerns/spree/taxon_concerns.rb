module Spree
  module TaxonConcerns
    extend ActiveSupport::Concern

    included do
      scope :non_root, -> { where('parent_id IS NOT NULL') }
      scope :random,   -> { order('RANDOM()') }

      scope :restaurants, -> { non_root.where(taxonomy: Spree::Taxonomy.restaurant) }
      scope :chefs,       -> { non_root.where(taxonomy: Spree::Taxonomy.chef) }
      scope :diets,       -> { non_root.where(taxonomy: Spree::Taxonomy.diets) }
      scope :allergens,   -> { non_root.where(taxonomy: Spree::Taxonomy.allergens) }
      scope :proteins,    -> { non_root.where(taxonomy: Spree::Taxonomy.proteins) }
      scope :pantry,      -> { non_root.where(taxonomy: Spree::Taxonomy.pantry) }
      scope :equipment,   -> { non_root.where(taxonomy: Spree::Taxonomy.equipment) }
      scope :pages,       -> { non_root.where(taxonomy: Spree::Taxonomy.pages) }
    end

    class_methods do
      def homepage
        pages.find_by!(name: "Home")
      end
    end
  end
end
