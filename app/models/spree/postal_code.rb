module Spree
  class PostalCode < Spree::Base
    belongs_to :state, class_name: 'Spree::State'
    belongs_to :country, class_name: 'Spree::Country'
    has_many :addresses, dependent: :nullify

    validates :value, :country_id, presence: true
    validate :postal_code_validate
    validates :value,
      numericality: { only_integer: true },
      length: { is: 5 }, if: Proc.new { |pc| country.try!(:iso).try(:downcase) == "us" } # Limit US ZIPs to 5 digits

    def <=>(other)
      value <=> other.value
    end

    def to_s
      value
    end

    private

    # Method borrowed from Spree::Address
    def postal_code_validate
      return if country.blank? || country.iso.blank?
      return if !TwitterCldr::Shared::PostalCodes.territories.include?(country.iso.downcase.to_sym)

      postal_code = TwitterCldr::Shared::PostalCodes.for_territory(country.iso)
      errors.add(:value, :invalid) if !postal_code.valid?(value)
    end
  end
end
