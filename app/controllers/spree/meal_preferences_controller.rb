class Spree::MealPreferencesController < ApplicationController
  # def index, show, new, edit, create, update, destroy
  def show
    @meal_preference = MealPreference.find(params[:id])
  end

  def new
    @meal_preference = MealPreference.new
  end

  def edit
    @meal_preference = MealPreference.find(params[:id])
  end

  def create
    @meal_preference = MealPreference.new(meal_preference_params)
    @meal_preference.spree_user_id = spree_current_user.id

    if @meal_preference.save
      redirect_to @meal_preference
    else
      render 'new'
    end
  end

  def update
    @meal_preference = MealPreference.find(params[:id])

    if @meal_preference.update(meal_preference_params)
      redirect_to @meal_preference
    else
      render 'edit'
    end
  end

  private
    def meal_preference_params
      params.require(:meal_preference).permit(:id, :diet_vegetarian, :diet_beef, :diet_lamb, :diet_poultry, :diet_pork, :diet_fish, :diet_seafood, :allergen_none, :allergen_eggs, :allergen_fish, :allergen_milk, :allergen_peanuts, :allergen_shellfish, :allergen_soybeans, :allergen_tree_nuts, :allergen_wheat_gluten)
    end
end
