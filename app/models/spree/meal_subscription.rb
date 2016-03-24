module Spree
  class MealSubscription < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new
    belongs_to :delivery_window

    def self.valid_meal_counts
      @valid_meal_counts ||= (1..6).to_a
    end

    validates :user_id, :status, :delivery_day, :delivery_window_id, :meal_count, presence: true
    validates :meal_count, numericality: { greater_than_or_equal_to: valid_meal_counts.first, less_than_or_equal_to: valid_meal_counts.last, only_integer: true }

    enum status: [:enabled, :disabled]
    enum delivery_day: [:monday, :tuesday, :wednesday]

    def valid_meal_counts
      self.class.valid_meal_counts
    end
  end
end