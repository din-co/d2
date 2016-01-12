module Spree
  module OrderConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      state_machine.before_transition to: :payment do |order|
        next true if order.delivery_window_selected?
        order.errors.add :base, Spree.t(:delivery_window_required)
        false
      end
    end

    module InstanceMethods
      def delivery_window_selected?
        shipments.first.try!(:selected_delivery_window).present?
      end
    end
  end
end
