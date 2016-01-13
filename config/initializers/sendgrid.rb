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

  Rails.application.config.x.redirect_emails_internally = ENV['SEND_REAL_EMAILS'].blank?

  ActionMailer::Base.register_interceptor(RedirectOutgoingEmail)
  ActionMailer::Base.register_interceptor(BccOutgoingEmail)
end
