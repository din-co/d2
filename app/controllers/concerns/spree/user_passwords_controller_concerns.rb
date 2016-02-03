module Spree
  module UserPasswordsControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_action :default_flash_message, only: [:create]
      after_action :unset_error_when_notice, only: [:create]
    end

    module InstanceMethods
      def default_flash_message
        set_flash_message(:error, :email_must_be_valid) if is_navigational_format?
      end

      def unset_error_when_notice
        flash.discard(:error) if flash.notice.present?
      end
    end
  end
end
