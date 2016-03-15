module Spree
  class MealPreferencesController < Spree::StoreController

    before_action :authorize_user
    before_action :set_meal_preference

    def create
      if @meal_preference.update_attributes(meal_preference_params)
        redirect_to spree.account_path
      else
        flash.now[:error] = @meal_preference.errors.full_messages.to_sentence
        render 'index'
      end
    end

    private

      def set_meal_preference
        @meal_preference = spree_current_user.meal_preference || spree_current_user.build_meal_preference
      end

      def meal_preference_params
        params.require(:meal_preference).permit(Spree::MealPreference.diets + Spree::MealPreference.allergens)
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
