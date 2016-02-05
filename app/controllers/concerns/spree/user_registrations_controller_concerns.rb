module Spree
  module UserRegistrationsControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      after_action :set_flash_for_registration, only: :create
    end

    module InstanceMethods
      private

      def set_flash_for_registration
        flash['user_signed_up'] = true if flash[:notice].present?
      end
    end
  end
end
