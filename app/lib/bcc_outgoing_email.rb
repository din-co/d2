class BccOutgoingEmail
  def self.delivering_email(mail)
    return if Rails.configuration.x.redirect_emails_internally
    mail.bcc ||= []
    mail.bcc += ["app-cc@din.co"]
  end
end
