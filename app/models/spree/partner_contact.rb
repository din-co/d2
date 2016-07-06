module Spree
  class PartnerContact < ActiveRecord::Base
    belongs_to :taxon
    validates :email, presence: true
  end
end
