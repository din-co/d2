module Spree
  class MasqueradesController < Devise::MasqueradesController

    # Prevents any non-admin from masquerading
    def show
      unless spree_current_user.try(:admin?)
        reset_session
        redirect_to new_user_session_path
        return
      end

      super
    end

  protected

    def after_masquerade_path_for(resource)
      spree.account_path
    end

    def after_back_masquerade_path_for(resource)
      spree.admin_users_path
    end
  end
end
