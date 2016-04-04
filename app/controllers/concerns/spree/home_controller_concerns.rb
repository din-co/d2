module Spree
  module HomeControllerConcerns
    extend ActiveSupport::Concern

    included do
      include ControllerHelpers::UserAuth
      prepend(InstanceMethods)

      helper_method :cache_key_for_products
      helper_method :cache_key_for_subscription_products
      before_filter :sort_by_taxon, only: :index
      before_action :authorize_user, only: :subscription_menu
    end

    module InstanceMethods

      def subscription_menu
        params[:taxon] = Spree::Taxon.subscription_menu.id
        @searcher = build_searcher(params.merge(include_images: true))
        @products = @searcher.retrieve_products
      end

    private

      # @return [String] a cache invalidation key for products (overrides Spree::ProductHelper#cache_key_for_products)
      def cache_key_for_products
        count = @products.count
        max_updated_at = (@products.maximum(:updated_at) || Date.today).to_s(:number)
        key = "#{I18n.locale}/#{current_currency}/spree/products/all-#{params[:page]}-#{max_updated_at}-#{count}-#{KITCHEN.status}"
        puts "HomeControllerConcerns.cache_key_for_products: #{key}"
        key
      end

      def cache_key_for_subscription_products
        "#{cache_key_for_products}-subscription"
      end

      def sort_by_taxon
        params[:taxon] = Spree::Taxon.homepage.id
      end
    end

  end
end
