module Spree
  module UsersControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)
    end

    module InstanceMethods
      def show
        super
        @personal_referral_promo = @user.personal_referral_promo
        if @orders.any?(&:complete?) && @personal_referral_promo.blank?
          @personal_referral_promo = @user.ensure_personal_referral_promo
        end
        cookies[:subscription_preview] = "true" if params[:subscription_preview].present?
      end
    end
  end
end
