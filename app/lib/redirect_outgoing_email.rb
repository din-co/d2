class RedirectOutgoingEmail
  def self.delivering_email(mail)
    return unless Rails.configuration.x.redirect_emails_internally
    to = mail.to
    cc = mail.cc
    bcc = mail.bcc
    mail.to = ["testing@din.co"]
    mail.cc = []
    mail.bcc = []
    recipients =  " to: #{to.join(',')}"
    recipients += " cc: #{cc.join(',')}" if cc.present?
    recipients += " bcc: #{bcc.join(',')}" if bcc.present?
    mail.subject = "[TEST#{recipients}] #{mail.subject}"
  end
end
