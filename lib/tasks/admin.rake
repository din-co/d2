namespace :admins do
  desc "Promote a user or users to the admin role by email address, set EMAILS='...' and separate with commas or spaces"
  task promote: :environment do
    emails = ENV['EMAILS'].split(',')
    if emails.size == 1
      emails = ENV['EMAILS'].split
    end
    emails = emails.map { |e| e.strip }
    roles = PromoteAdmin.promote(emails)
    promoted = roles.map { |r| r.user.email }
    Rails.logger.info "Promoted: #{promoted.join(', ')}"
  end
end
