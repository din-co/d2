module Spree
  module OrdersControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :redirect_empty_order_to_menu, only: :edit
    end

    module InstanceMethods
      private

      def redirect_empty_order_to_menu
        redirect_to spree.root_path if current_order.try!(:quantity) < 1
      end
    end
  end
end
