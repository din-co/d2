module Spree
  class PostalCode < Spree::Base
    belongs_to :state, class_name: 'Spree::State'
    belongs_to :country, class_name: 'Spree::Country'
    has_many :addresses, dependent: :nullify

    validates :value, presence: true
    # FIXME: validate that value is correct for country
    #        See Spree::Address#postal_code_validate

    def <=>(other)
      value <=> other.value
    end

    def to_s
      value
    end
  end
end
