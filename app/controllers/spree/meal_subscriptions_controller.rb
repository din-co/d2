module Spree
  class MealSubscriptionsController < Spree::StoreController

    before_action :authorize_user
    before_action :set_meal_subscription

    helper_method :delivery_zone

    def create
      if @meal_subscription.update_attributes(meal_subscription_params)
        redirect_to spree.account_path
      else
        flash.now[:error] = @meal_subscription.errors.full_messages.join(" ")
        render 'show'
      end
    end

  private

    def meal_subscription_params
      params.require(:meal_subscription).permit(:status, :delivery_day, :delivery_window_id, :meal_count, :notification_sms)
    end

    def delivery_zone
      Spree::Zone.match(spree_current_user.default_address)
    end

    def set_meal_subscription
      @meal_subscription = spree_current_user.meal_subscription || spree_current_user.build_meal_subscription
      @meal_subscription.delivery_window ||= delivery_zone.try(:delivery_windows).try(:first)
    end

    def authorize_user
      unless spree_current_user.present?
        store_location
        redirect_to login_path
        return
      end
    end

  end
end
