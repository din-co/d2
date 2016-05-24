
module Spree
  module AddressConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      belongs_to :postal_code, class_name: "Spree::PostalCode"
      before_validation :associate_postal_code, if: Proc.new { |addr| addr.postal_code_id.blank? || addr.zipcode_changed? }

      validate :shipping_validate, on: :shipping
      validates :phone, presence: true, on: :shipping
      validate :phone_validate, if: 'phone.present?', on: :shipping
    end

    module InstanceMethods
      def require_phone?
        false
      end
      def one_line
        [address1, address2.presence, city, state].compact.join(", ") + " #{zipcode}"
      end
    end

    private

    def shipping_validate
      if postal_code.blank? || Spree::Zone.match(self).blank?
        errors.add :base, Spree.t(:unsupported_delivery_location, locations: Spree::Zone.pluck(:name).to_sentence)
      end
    end

    def phone_validate
      unless phone.gsub(/\D/, '') =~ /^1?\d{10}$/
        errors.add :phone, Spree.t(:invalid_phone_number)
      end
    end

    # Overrides original method
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
