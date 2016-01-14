class Legacy::MysqlBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection configurations['legacy'][Rails.env]
end
