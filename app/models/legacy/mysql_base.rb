class Legacy::MysqlBase < ActiveRecord::Base
  establish_connection configurations['legacy'][Rails.env]
  self.abstract_class = true
end
