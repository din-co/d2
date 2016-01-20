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
        unless KITCHEN.open?
          prepare_kitchen
          render :kitchen_closed
        end
      end

      def sort_by_taxon
        params[:taxon] = Spree::Taxon.pages.find_by(name: "Home").try(:id)
      end

      private
      def prepare_kitchen
        @kitchen_reopens = KITCHEN.next_opens
        # TODO: change products to "coming soon" collection
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
        @taxonomies = Spree::Taxonomy.includes(root: :children)
      end
    end
  end
end
