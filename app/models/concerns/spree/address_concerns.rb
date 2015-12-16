module Spree
  module AddressConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      belongs_to :postal_code, class_name: "Spree::PostalCode"
      after_validation :associate_postal_code
    end

    module InstanceMethods
      def require_phone?
        false
      end
    end

    private
      def associate_postal_code
        return true if zipcode.blank?

        code = if country.iso && country.iso.downcase.to_sym == :us
                 zipcode.first(5)
               else
                 zipcode
               end

        postal_obj = Spree::PostalCode.where(value: code, country: country).first_or_create
        # Need to use assign_attributes when in callback
        assign_attributes(postal_code_id: postal_obj.id) and true
      end
  end
end
