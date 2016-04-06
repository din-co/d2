module Spree
  class MasqueradesController < Devise::MasqueradesController

    before_action :allow_only_admins, only: :show

  protected

    # Prevents any non-admin from masquerading
    def allow_only_admins
      unless spree_current_user.try(:admin?)
        reset_session
        redirect_to spree.login_path
      end
    end

    def after_masquerade_path_for(resource)
      spree.account_path
    end

    def after_back_masquerade_path_for(resource)
      spree.admin_users_path
    end
  end
end
