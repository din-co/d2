module Spree
  module UserConcerns
    extend ActiveSupport::Concern

    included do
      has_one :meal_preference, class_name: 'Spree::MealPreference' #, dependent: :destroy
    end
  end
end
