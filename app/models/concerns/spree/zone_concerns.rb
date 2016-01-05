module Spree
  module ZoneConcerns
    extend ActiveSupport::Concern

    # Override default instance methods by prepending the below module
    module InstanceMethods
      # Override to include Spree::PostalCode as option
      def include?(address)
        return false unless address

        members.any? do |zone_member|
          case zone_member.zoneable_type
          when 'Spree::Country'
            zone_member.zoneable_id == address.country_id
          when 'Spree::State'
            zone_member.zoneable_id == address.state_id
          when 'Spree::PostalCode'
            zone_member.zoneable_id == address.postal_code_id
          else
            false
          end
        end
      end

      # Override to include 'postal_code' zoneable types
      def country_list
        @countries ||= case kind
                       when 'country' then zoneables
                       when 'state', 'postal_code' then zoneables.collect(&:country)
                       else []
                       end.flatten.compact.uniq
      end

      # Indicates whether the specified zone falls entirely within the zone performing
      # the check, overridden to include postal code types.
      #
      # Base.kind      | Target.kind   | Result
      # country        | country       | true if equal, false otherwise
      # country        | state         | true if contained, false otherwise
      # country        | postal_code   | true if contained, false otherwise
      # state          | country       | false
      # state          | state         | true if equal, false otherwise
      # state          | postal_code   | true if contained, false otherwise
      # postal_code    | country       | false
      # postal_code    | state         | false
      # postal_code    | postal_code   | true if equal, false otherwise
      def contains?(target)
        return false if kind == 'state' && target.kind == 'country'
        return false if kind == 'postal_code' && target.kind == 'country'
        return false if kind == 'postal_code' && target.kind == 'state'
        return false if zone_members.empty? || target.zone_members.empty?

        if kind == target.kind
          return false if (target.zoneables.collect(&:id) - zoneables.collect(&:id)).present?
        else
          case kind
          when 'country'
            # target is postal_code or state
            return false if (target.zoneables.collect(&:country).collect(&:id) - zoneables.collect(&:id)).present?
          when 'state'
            # target is postal_code
            # we are not guaranteed that a postal code zoneable has an associated state,
            #   so we only grab the array of existing states
            target_states = target.zoneables.collect(&:state).compact
            return false if target_states.empty?
            return false if (target_states.collect(&:id) - zoneables.collect(&:id)).present?
          end
        end
        true
      end

      def available_delivery_windows
        current_hour = Time.now.hour

        delivery_windows.
          where("start_hour - lead_time_duration > ?", current_hour)
      end
    end

    included do
      prepend(InstanceMethods)

      has_many :delivery_window_zones, class_name: "Spree::DeliveryWindowZone"
      has_many :delivery_windows, through: :delivery_window_zones

      # Override Spree::Zone.match to return PostalCode zone types if found.
      # Returns the matching zone with the highest priority zone type (PostalCode, State, Country, Zone.)
      # Returns nil in the case of no matches.
      def self.match(address)
        return unless address and matches = self.includes(:zone_members).
          order(:zone_members_count, :created_at, :id).
          where("
            (spree_zone_members.zoneable_type = 'Spree::Country' AND spree_zone_members.zoneable_id = ?)
            OR
            (spree_zone_members.zoneable_type = 'Spree::State' AND spree_zone_members.zoneable_id = ?)
            OR
            (spree_zone_members.zoneable_type = 'Spree::PostalCode' AND spree_zone_members.zoneable_id = ?)
          ", address.country_id, address.state_id, address.postal_code_id).
          references(:zones)

        ['postal_code', 'state', 'country'].each do |zone_kind|
          if match = matches.detect { |zone| zone_kind == zone.kind }
            return match
          end
        end
        matches.first
      end
    end

    # New (non-overidden) instance methods

    def postal_code_ids
      if kind == 'postal_code'
        members.pluck(:zoneable_id)
      else
        []
      end
    end

    def postal_code_ids=(ids)
      set_zone_members(ids, 'Spree::PostalCode')
    end
  end
end
