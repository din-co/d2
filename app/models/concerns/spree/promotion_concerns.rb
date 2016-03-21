module Spree
  module PromotionConcerns
    extend ActiveSupport::Concern

    included do
      belongs_to :user, class_name: Spree::UserClassHandle.new
    end
  end
end
