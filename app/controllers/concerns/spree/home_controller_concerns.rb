module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      include ControllerHelpers::UserAuth
      prepend(InstanceMethods)

      helper_method :cache_key_for_products
      helper_method :cache_key_for_subscription_products
      before_action :authorize_user, only: :subscription_menu
    end

    module InstanceMethods

      def index
        @taxon = Spree::Taxon.homepage
        params.merge!(taxon: @taxon.id)
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
      end

      def subscription_menu
        @taxon = Spree::Taxon.subscription_menu
        params[:taxon] = @taxon.id
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
      end

    private

      # @return [String] a cache invalidation key for products (overrides Spree::ProductHelper#cache_key_for_products)
      def cache_key_for_products
        count = @products.count
        max_updated_at = [Time.current.midnight, @products.maximum(:updated_at), @taxon.try(:updated_at)].compact.max.to_s(:number)
        "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{KITCHEN.status}"
      end

      def cache_key_for_subscription_products
        "#{cache_key_for_products}-subscription"
      end

      def sort_by_taxon
      end
    end

  end
end
