module Spree
  module OrderConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      state_machine.before_transition to: :payment do |order|
        unless order.delivery_window_selected?
          order.errors.add :base, Spree.t(:delivery_window_required)
          false
        end
      end

      state_machine.after_transition to: :complete do |order|
        order.user.ensure_personal_referral_promo
      end

      validate :validate_ship_address

      state_machine.before_transition to: :delivery do |order|
        order.send(:validate_ship_address)
        return false if order.errors[:ship_address].present?
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

      attr_reader :shipping_promotion_calculator # set once shipping_promotion_minimal_calculator is called

      public :use_billing?
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

      def delivery_day_and_window
        # Needs to be updated with "delivery_at" date.
        "#{completed_at.to_s(:weekday_month_day_short)}, #{delivery_window}"
      end

      def delivery_summary
        item_names = line_items.map { |line_item| "#{line_item.quantity} × #{line_item.name}" }
        "#{delivery_day_and_window}: #{item_names.to_sentence}."
      end

      def shipping_promotion_difference
        if amt = shipping_promotion_minimal_amount
          Spree::Money.new(amt - display_item_total.money)
        else
          Spree::Money.new(0)
        end
      end

      def discounted_shipping_cost
        if calc = shipping_promotion_minimal_calculator
          if calc.preferred_discount_amount == 0.0
            Spree.t(:free)
          else
            Spree::Money.new(calc.preferred_discount_amount)
          end
        end
      end

      def tote_tags_count
        (quantity/3.0).ceil
      end

      def tote_tags
        total_tags = tote_tags_count
        # Prototype tag
        tag_attributes = {
          order_number:    number,
          tag_number:      1,
          total_tags:      total_tags,
          name:            "#{ship_address.firstname} #{ship_address.lastname}",
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
        packing_list = line_items.includes(product: :taxons).map do |line_item|
            TagLineItem.new({
              name:       line_item.product.name,
              quantity:   line_item.quantity,
              restaurant: line_item.product.restaurant,
              chef:       line_item.product.chef,
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

    private

    def validate_ship_address
      if ship_address.present?
        unless ship_address.valid?
          ship_address.errors.each { |attr, err| errors.add :ship_address, err }
          return
        end
        unless ship_address.valid?(:shipping)
          ship_address.errors.each { |attr, err| errors.add :ship_address, err }
          return
        end
      end
    end

    def shipping_promotion_minimal_amount
      if calc = shipping_promotion_minimal_calculator
        Spree::Money.new(shipping_promotion_minimal_calculator.preferred_minimal_amount).money
      end
    end

    def shipping_promotion_minimal_calculator
      return @shipping_promotion_calculator if defined?(@shipping_promotion_calculator)
      shipment = shipments.first
      return nil unless shipment.try(:shipping_rates).present?
      valid_shipping_rates = shipment.shipping_rates.select { |rate| rate.shipping_method.delivery_windows.any?(&:currently_available?) }
      calculators = valid_shipping_rates.map { |rate| rate.shipping_method.calculator }
      calculators = calculators.select { |calc| calc.respond_to?(:preferred_minimal_amount) }
      @shipping_promotion_calculator = calculators.min_by { |calc| calc.preferred_minimal_amount }
    end
  end
end
