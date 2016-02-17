FactoryGirl.define do
  factory :postal_code, class: Spree::PostalCode do
    value '94110'
    state do |postal_code|
      if california = Spree::State.find_by_name("California")
        california
      else
        postal_code.association(:state)
      end
    end
    country do |postal_code|
      if postal_code.state
        postal_code.state.country
      elsif usa = Spree::Country.find_by_numcode(840)
        usa
      else
        postal_code.association(:country)
      end
    end
  end

end
