module Spree
  module OrdersControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :redirect_empty_order_to_menu, only: :edit
      before_filter :disallow_out_of_stock_items, only: :populate
    end

    module InstanceMethods
      private

      def redirect_empty_order_to_menu
        redirect_to spree.root_path if current_order.try!(:quantity) < 1
      end

      def disallow_out_of_stock_items
        variant  = Spree::Variant.find(params[:variant_id])
        quantity = params[:quantity].to_i
        unless Stock::Quantifier.new(variant).can_supply?(quantity)
          flash[:error] = Spree.t(:inventory_error_flash_for_insufficient_quantity)
          begin
            redirect_to :back
          rescue ActionController::RedirectBackError
            redirect_to root_path
          end
        end
      end
    end
  end
end
