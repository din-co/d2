class RedirectOutgoingEmail
  def self.delivering_email(mail)
    return unless Rails.configuration.x.redirect_emails_internally
    to = mail.to
    cc = mail.cc
    bcc = mail.bcc

    # Clear all recipients except testing
    mail.to = ["testing@din.co"]
    mail.cc = []
    mail.bcc = []

    # Allow din.co recipients
    to.each do |t|
        mail.to << t if t.ends_with? "@din.co"
    end

    # Display recipients in subject line
    recipients =  " to: #{to.join(',')}"
    recipients += " cc: #{cc.join(',')}" if cc.present?
    recipients += " bcc: #{bcc.join(',')}" if bcc.present?
    mail.subject = "[TEST#{recipients}] #{mail.subject}"
  end
end
