module Spree
  module AddressConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      belongs_to :postal_code, class_name: "Spree::PostalCode"
      before_validation :associate_postal_code, if: Proc.new { |addr| postal_code_id.blank? }
    end

    module InstanceMethods
      def require_phone?
        false
      end

      def postal_code_value
        postal_code.try(:value) || zipcode
      end
    end

    private
      def postal_code_validate
        super
        # ensure associated postal_code belongs to country
        if postal_code.present?
          if postal_code.country != country
            if zipcode.present? # reset association
              self.postal_code = nil
            else
              errors.add(:postal_code, :invalid)
            end
          end
        end

        # ensure at least one of postal_code or zipcode is populated
        errors.add :postal_code, :blank if postal_code.blank? && zipcode.blank?
      end

      def associate_postal_code
        return true if zipcode.blank? || country.blank?
        code = country.try!(:iso) == "US" ? zipcode.to_s.first(5) : zipcode
        self.postal_code = Spree::PostalCode.find_by(value: code, country: country)
      end
  end
end
