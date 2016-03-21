module ControllerHelpers
  module UserAuth

    private

    def authorize_user
      unless spree_current_user.present?
        store_location
        redirect_to login_path
        return
      end
    end
  end
end
