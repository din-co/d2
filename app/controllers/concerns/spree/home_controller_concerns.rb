module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :kitchen_hours, only: :index
      before_filter :sort_by_taxon, only: :index
    end

    module InstanceMethods
      def kitchen_hours
        if kitchen_closed?
          prepare_kitchen
          render :kitchen_closed
        end
      end

      def sort_by_taxon
        params[:taxon] = Spree::Taxon.pages.find_by(name: "Home").try(:id)
      end

      private
      def kitchen_closed?
        # return true
        !Time.current.between?(kitchen_opening, kitchen_closing)
      end

      def prepare_kitchen
        @kitchen_reopens = kitchen_reopens
        # TODO: change products to "coming soon" collection
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
      end

      def kitchen_opening
        Time.current.monday
      end

      def kitchen_closing
        kitchen_opening.advance(days: 2).end_of_day
      end

      def kitchen_reopens
        kitchen_opening.advance(week: 1)
      end
    end
  end
end
