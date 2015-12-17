class Legacy::User < Legacy::MysqlBase
  has_many :meta, class_name: 'Legacy::UserMeta', inverse_of: :user

  %w( address apt_suite city state zip phone card_type last4 ).each do |meta_name|
    define_method meta_name.to_sym do
      meta.detect { |m| m.meta == meta_name }
    end
  end
end
