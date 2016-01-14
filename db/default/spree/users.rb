# This file overrides the built-in users.rb from solidus_auth_devise to automatically
# create an admin user if there are no admin user accounts.

unless Spree::User.admin.exists?
  admin = Spree::User.create! do |u|
    u.email = "admin@din.co"
    u.password = "password"
    u.password_confirmation = "password"
    u.login = u.email
  end
  role = Spree::Role.find_or_create_by!(name: 'admin')
  admin.spree_roles << role
  admin.save
  admin.generate_spree_api_key!
end
