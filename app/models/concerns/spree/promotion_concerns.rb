module Spree
  module PromotionConcerns
    extend ActiveSupport::Concern

    included do
      # prepend(InstanceMethods)

      belongs_to :user, class_name: Spree::UserClassHandle.new
    end

    # module InstanceMethods
    # end
  end
end
