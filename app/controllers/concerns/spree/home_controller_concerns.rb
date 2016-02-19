module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
      helper_method :cache_key_for_products

      before_filter :sort_by_taxon, only: :index
    end

    module InstanceMethods
      private

      # @return [String] a cache invalidation key for products (overrides Spree::ProductHelper#cache_key_for_products)
      def cache_key_for_products
        count = @products.count
        max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
        "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{KITCHEN.status}"
      end

      def sort_by_taxon
        params[:taxon] = Spree::Taxon.homepage.id
      end
    end

  end
end
