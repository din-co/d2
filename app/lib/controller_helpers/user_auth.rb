module ControllerHelpers
  module UserAuth

    private

    def authorize_user
      @user = spree_current_user
      unless @user.present?
        store_location
        redirect_to login_path
        return
      end
    end
  end
end
