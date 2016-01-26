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

      scope :day_of, ->(t) { completed_between(t.midnight, t.end_of_day) }
      scope :not_canceled, -> { where(canceled_at: nil) }
      scope :shippable_day_of, ->(t) { day_of(t).not_canceled }
    end

    class_methods do
      def csv_headers
        [
          "order_number",
          "order_status",
          "delivery_number",
          "delivery_status",
          "full_name",
          "address1",
          "address2",
          "city",
          "state",
          "zip",
          "delivery_instructions",
          "ship_date",
          "delivery_window",
          "courier",
          "restaurant",
          "product",
          "quantity",
        ]
      end
    end

    module InstanceMethods
      def delivery_window_selected?
        shipments.first.try!(:selected_delivery_window).present?
      end

      def tote_tags
        if quantity < 3
          [self]
        else
          raise NotImplementedError
        end
      end

      def to_csv_data
        shipment = shipments.first
        line_items.includes(:product).map do |line_item|
          [
            number,
            state,
            shipment.number,
            shipment.state,
            name,
            ship_address.address1,
            ship_address.address2,
            ship_address.city,
            ship_address.state.abbr,
            ship_address.zipcode,
            ship_address.phone,
            special_instructions,
            completed_at,
            shipment.selected_delivery_window.to_s,
            '<courier>',
            line_item.product.restaurant.name,
            line_item.product.name,
            line_item.quantity
          ]
        end
      end
    end
  end
end
