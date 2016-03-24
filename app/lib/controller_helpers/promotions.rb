module ControllerHelpers
  module Promotions
    extend ActiveSupport::Concern
    included do

      private

      def apply_page_promotion
        if promo_path = cookies.signed[:page_promotion].presence
          if (@promo = Spree::Promotion.active.find_by(path: promo_path)) && @promo.user != spree_current_user
            if Spree::PromotionHandler::Page.new(@order, @promo.path).activate
              @order.update!
              cookies.delete(:page_promotion)
            end
          end
        end
      end
    end
  end
end
