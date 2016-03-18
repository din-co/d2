module Spree
  module UsersControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def show
        super
        @personal_referral_promo = @user.ensure_personal_referral_promo if @orders.any?(&:complete?)
      end
    end
  end
end
