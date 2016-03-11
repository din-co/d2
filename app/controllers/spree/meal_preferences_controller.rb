module Spree
  class MealPreferencesController < Spree::StoreController
    def index
      @meal_preference = spree_current_user.meal_preference
    end

    def create
      @meal_preference = MealPreference.new(meal_preference_params)
      @meal_preference.user_id = spree_current_user.id

      if @meal_preference.save
        redirect_to spree.account_path
      else
        render 'index'
      end
    end

    def update
      @meal_preference = MealPreference.find(params[:id])

      if @meal_preference.update(meal_preference_params)
        redirect_to spree.account_path
      else
        render 'index'
      end
    end

    private
      def meal_preference_params
        params.require(:meal_preference).permit(:id, :diet_beef, :diet_lamb, :diet_pork, :diet_poultry, :diet_rabbit, :diet_fish, :diet_seafood, :diet_tofu, :diet_tempeh, :allergen_none, :allergen_eggs, :allergen_fish, :allergen_milk, :allergen_peanuts, :allergen_shellfish, :allergen_soybeans, :allergen_tree_nuts, :allergen_wheat_gluten)
      end
  end
end
