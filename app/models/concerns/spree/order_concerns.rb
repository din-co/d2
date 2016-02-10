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
      scope :with_delivery_window, ->(id) { joins(:shipments).where("spree_shipments.delivery_window_id" => id) }
      scope :including_tote_data, -> {
        includes(:ship_address, {shipments: :selected_delivery_window})
          .references(:spree_shipments, :spree_addresses)
          .order("spree_shipments.delivery_window_id")
          .order("spree_addresses.firstname")
      }
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
      def delivery_window
        shipments.first.try!(:selected_delivery_window)
      end

      def delivery_window_selected?
        delivery_window.present?
      end

      def tote_tags_count
        n = shipments.first.pre_shipment_manifest.sum(&:quantity)
        (n/3.0).ceil
      end

      def tote_tags
        total_tags = tote_tags_count
        return [] if total_tags == 0

        # Prototype tag
        tag_attributes = {
          order_number:    number,
          tag_number:      1,
          total_tags:      total_tags,
          name:            name,
          address1:        ship_address.address1,
          address2:        ship_address.address2,
          city:            ship_address.city,
          state:           ship_address.state.abbr,
          zipcode:         ship_address.zipcode,
          phone:           ship_address.phone,
          instructions:    special_instructions,
          delivery_window: shipments.first.selected_delivery_window,
        }

        # Include packing list only on the first tag.
        packing_list = shipments.first.pre_shipment_manifest  .map do |manifest_item|
            TagLineItem.new({
              name:       manifest_item.variant.name,
              quantity:   manifest_item.quantity,
              restaurant: manifest_item.variant.product.restaurant,
              chef:       manifest_item.variant.product.chef,
            })
        end

        tags = [ToteTag.new(tag_attributes.merge(packing_list: packing_list))]

        # Generate an extra tag without line items for each group of 3 items
        2.upto(total_tags) { |n| tags << ToteTag.new(tag_attributes.merge(tag_number: n)) }

        tags
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

    ToteTag = ImmutableStruct.new(
      :order_number,
      :tag_number,
      :total_tags,
      :name,
      :address1,
      :address2,
      :city,
      :state,
      :zipcode,
      :phone,
      :instructions,
      :delivery_window,
      [:packing_list]
    )
    TagLineItem = ImmutableStruct.new(:name, :quantity, :restaurant, :chef)

  end
end
