FactoryGirl.modify do
  factory :address do
    zipcode "94110"
    postal_code { Spree::PostalCode.find_by(value: zipcode) if zipcode.present? }
    state { postal_code.try(:state) || association(:state) }
  end
end
