module Spree
  module Admin
    class SubscriptionsController < Spree::Admin::BaseController
      def meals
        @products = Spree::Taxon.subscription_menu.products
      end
    end
  end
end
