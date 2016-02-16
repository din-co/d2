module Spree
  module AddressConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      belongs_to :postal_code, class_name: "Spree::PostalCode"

      # Finer grained control over validations than Spree::Address
      clear_validators!
      # Duplicate some validations
      validates :zipcode, presence: true, if: :require_zipcode?
      validates :phone, presence: true, if: :require_phone?
      # Selectively apply validations, rather than all the time.
      with_options if: :used_for_shipping? do
        validates :firstname, :lastname, :address1, :city, :country_id, presence: true
        validate :state_validate, :postal_code_validate
      end
      # END duplicated validations

      # Prevent comparing address equality against these attributes
      Spree::Address::DB_ONLY_ATTRS << "used_for_shipping"

      after_validation :associate_postal_code, if: Proc.new { |address| address.postal_code_id.blank? && address.errors.empty? }
    end

    module InstanceMethods
      def require_phone?
        false
      end
    end

    private
      def associate_postal_code
        return true if zipcode.blank?
        code = country.try!(:iso).try(:downcase) == "us" ? zipcode.first(5) : zipcode
        postal_code = Spree::PostalCode.find_by(value: code, country: country)
        if used_for_shipping?
          if postal_code.blank?
            errors[:base] = Spree.t(:unsupported_delivery_location)
            return false
          end
          # Need to use assign_attributes when in callback
          assign_attributes(postal_code_id: postal_code.id)
        end
      end
  end
end
