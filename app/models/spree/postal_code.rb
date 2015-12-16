module Spree
  class PostalCode < Spree::Base
    belongs_to :state, class_name: 'Spree::State'
    belongs_to :country, class_name: 'Spree::Country'
    has_many :addresses, dependent: :nullify

    validates :value, :country, presence: true
    validate :postal_code_validate, :us_restrict_digits_validate

    def <=>(other)
      value <=> other.value
    end

    def to_s
      value
    end

    private

      # Some code here borrowed from Spree::Address
      def postal_code_validate
        return if country.blank? || country.iso.blank?
        return if !TwitterCldr::Shared::PostalCodes.territories.include?(country.iso.downcase.to_sym)

        postal_code = TwitterCldr::Shared::PostalCodes.for_territory(country.iso)
        errors.add(:value, :invalid) if !postal_code.valid?(value)
      end

      # Ensure only five digit postal codes exist for Spree::PostalCodes in US
      def us_restrict_digits_validate
        if (country.iso && country.iso.downcase.to_sym == :us)
          errors.add(:value, :invalid) if value.length > 5
        end
      end
  end
end
