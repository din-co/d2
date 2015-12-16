class Legacy::User < Legacy::MysqlBase
  has_many :meta, class_name: 'Legacy::UserMeta'

  has_one :address,   -> { address }, class_name: 'Legacy::UserMeta'
  has_one :apt_suite, -> { apt_suite }, class_name: 'Legacy::UserMeta'
  has_one :city,      -> { city }, class_name: 'Legacy::UserMeta'
  has_one :state,     -> { state }, class_name: 'Legacy::UserMeta'
  has_one :zip,       -> { zip }, class_name: 'Legacy::UserMeta'
  has_one :phone,     -> { phone }, class_name: 'Legacy::UserMeta'

  has_one :card_type, -> { card_type }, class_name: 'Legacy::UserMeta'
  has_one :last4,     -> { last4 }, class_name: 'Legacy::UserMeta'
end
