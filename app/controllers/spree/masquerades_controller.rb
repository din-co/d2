module Spree
  class MasqueradesController < Devise::MasqueradesController

    # Prevents any non-admin from masquerading
    def show
      unless spree_current_user.try(:admin?)
        reset_session
        redirect_to root_path
        return
      end

      super
    end
  end
end
