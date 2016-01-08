module Spree
  module TaxonConcerns
    extend ActiveSupport::Concern

    included do
      scope :non_root, -> { where('parent_id IS NOT NULL') }
      scope :random,   -> { order('RANDOM()') }

      scope :restaurant, -> { non_root.where(taxonomy: Spree::Taxonomy.restaurant) }
      scope :chef,       -> { non_root.where(taxonomy: Spree::Taxonomy.chef) }
      scope :diets,      -> { non_root.where(taxonomy: Spree::Taxonomy.diets) }
      scope :allergens,  -> { non_root.where(taxonomy: Spree::Taxonomy.allergens) }
      scope :pantry,     -> { non_root.where(taxonomy: Spree::Taxonomy.pantry) }
      scope :equipment,  -> { non_root.where(taxonomy: Spree::Taxonomy.equipment) }
    end
  end
end
