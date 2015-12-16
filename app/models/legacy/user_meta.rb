class Legacy::UserMeta < Legacy::MysqlBase
  self.table_name = "user_meta"

  belongs_to :user

  scope :address,   -> { where(meta: 'address') }
  scope :apt_suite, -> { where(meta: 'apt_suite') }
  scope :city,      -> { where(meta: 'city') }
  scope :state,     -> { where(meta: 'state') }
  scope :zip,       -> { where(meta: 'zip') }
  scope :phone,     -> { where(meta: 'phone') }

  scope :card_type, -> { where(meta: 'card_type') }
  scope :last4,     -> { where(meta: 'last4') }
end
