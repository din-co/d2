class Legacy::User < Legacy::MysqlBase
  has_many :meta, class_name: 'Legacy::UserMeta', inverse_of: :user

  default_scope -> { includes(:meta) }

  %w( address apt_suite city state zip phone last4 ).each do |meta_name|
    define_method meta_name.to_sym do
      meta.detect { |m| m.meta == meta_name }.try(:value)
    end
  end

  CARD_TYPES = {
    "American Express" => :american_express,
    "Discover" => :discover,
    "MasterCard" => :master,
    "Visa" => :visa,
  }

  def card_type
    CARD_TYPES[meta.detect { |m| m.meta == "card_type" }.try(:value)]
  end
end
