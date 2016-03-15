module Spree
  class MealPreferencesController < Spree::StoreController

    before_action :authorize_user

    # before_action :vegetarian_and_no_soy, only: [:update, :create]

    def index
      @meal_preference = spree_current_user.meal_preference
    end

    def create
      @meal_preference = MealPreference.new(meal_preference_params)
      @meal_preference.user_id = spree_current_user.id

      if @meal_preference.save
        redirect_to spree.account_path
      else
        flash.now[:error] = @meal_preference.errors.full_messages.to_sentence
        render 'index'
      end
    end

    def update
      @meal_preference = spree_current_user.meal_preference

      if @meal_preference.update(meal_preference_params)
        redirect_to spree.account_path
      else
        flash.now[:error] = @meal_preference.errors.full_messages.to_sentence
        render 'index'
      end
    end

    private

      def meal_preference_params
        params.require(:meal_preference).permit(:id, :diet_beef, :diet_lamb, :diet_pork, :diet_poultry, :diet_rabbit, :diet_fish, :diet_seafood, :diet_tofu, :diet_tempeh, :allergen_none, :allergen_eggs, :allergen_fish, :allergen_milk, :allergen_peanuts, :allergen_shellfish, :allergen_soybeans, :allergen_tree_nuts, :allergen_wheat_gluten)
      end

      # def vegetarian_and_no_soy
      #   if @meal_preference.allergen_soybeans && (@meal_preference.diet_tofu || @meal_preference.diet_tempeh)
      #     flash[:error] = "If you don’t eat soybeans, then you probably shouldn’t select tofu or tempeh."
      #     redirect_to meal_preferences_path
      #   end
      # end

      def authorize_user
        unless spree_current_user.present?
          store_location
          redirect_to login_path
          return
        end
      end

  end
end
