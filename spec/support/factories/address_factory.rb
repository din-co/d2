FactoryGirl.modify do
  factory :address do
    zipcode "94110"
    postal_code do |address|
      if postal_code = Spree::PostalCode.find_by(value: address.zipcode)
        address.postal_code = postal_code
      else
        address.association(:postal_code)
      end
    end
    state do |address|
      if address.postal_code
        address.postal_code.state
      else
        address.association(:state)
      end
    end
  end
end
