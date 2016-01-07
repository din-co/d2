
# This file overrides the built-in users.rb from solidus_auth_devise to automatically
# create an admin user in development mode.

if Rails.env.development? && Spree::User.admin.empty?
  admin = Spree::User.find_or_create_by!(email: "admin@din.co") do |u|
    u.password = "password"
    u.password_confirmation = "password"
    u.login = u.email
  end
  role = Spree::Role.find_or_create_by!(name: 'admin')
  admin.spree_roles << role
  admin.save
  admin.generate_spree_api_key!
end
