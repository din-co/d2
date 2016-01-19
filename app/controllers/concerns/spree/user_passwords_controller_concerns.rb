module Spree
  module UserPasswordsControllerConcerns
    extend ActiveSupport::Concern

    included do
      prepend(InstanceMethods)

      before_filter :default_flash_message, only: [:create]
    end

    module InstanceMethods
      def default_flash_message
        set_flash_message(:error, :email_must_be_valid) if is_navigational_format?
      end
    end
  end
end
