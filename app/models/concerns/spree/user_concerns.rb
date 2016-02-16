module Spree
  module UserConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def ship_address=(address)
        address.used_for_shipping = true if address
        super
      end
    end
  end
end
