if Rails.env.production?
  Rails.application.config.action_mailer.smtp_settings = {
    :address        => 'smtp.sendgrid.net',
    :port           => '587',
    :authentication => :plain,
    :user_name      => ENV['SENDGRID_USERNAME'],
    :password       => ENV['SENDGRID_PASSWORD'],
    :domain         => 'heroku.com',
    :enable_starttls_auto => true
  }

  # Production doesn't send real email unless SEND_REAL_EMAILS is set
  block_real_emails = ENV['SEND_REAL_EMAILS'].blank?
  Rails.configuration.x.redirect_emails_internally = block_real_emails
  Rails.application.config.action_mailer.show_previews = block_real_emails

  ActionMailer::Base.register_interceptor(RedirectOutgoingEmail)
  ActionMailer::Base.register_interceptor(BccOutgoingEmail)
end
