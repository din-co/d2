module Spree
  module AddressConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def require_phone?
        false
      end
    end
  end
end
