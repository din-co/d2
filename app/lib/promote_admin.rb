class PromoteAdmin
  def self.promote(emails)
    Spree::User.where(email: emails).map do |user|
      user.role_users.find_or_create_by(role: admin_role)
    end
  end

  def self.admin_role
    Spree::Role.find_by!(:name => "admin")
  end
end
