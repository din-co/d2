class Legacy::UserMeta < Legacy::MysqlBase
  self.table_name = "user_meta"

  belongs_to :user, inverse_of: :meta
end
