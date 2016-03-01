FactoryGirl.define do
  factory :postal_code, class: Spree::PostalCode do
    sequence(:value, 99000) { |n|  n.to_s }
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
