zone = Spree::Zone.find_or_create_by!(name: "San Francisco") do |s|
  s.description = "San Francisco Proper - The 7x7"
  s.default_tax = false
end

# San Francisco postal codes
postal_codes = %w(
  94102 94103 94107 94108 94109 94110 94112
  94114 94115 94116 94117 94118 94121 94122
  94123 94124 94127 94131 94132 94133 94134
).map do |p|
  Spree::PostalCode.find_or_create_by!(value: p, country: Spree::Country.default)
end

# Add zip codes as members of this shipping zone
postal_codes.each do |p|
	zone.zone_members.create!(zoneable: p)
end

