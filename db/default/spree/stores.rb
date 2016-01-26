unless Spree::Store.where(code: 'din').exists?
  Spree::Store.create! do |s|
    s.code              = 'din'
    s.name              = 'Din'
    s.url               = 'din.co'
    s.mail_from_address = 'Din <cook@din.co>'
    s.default           = true
  end
end
