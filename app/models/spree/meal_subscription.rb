module Spree
  class MealSubscription < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new
    belongs_to :delivery_window

    validates :user_id, :status, :delivery_day, :delivery_window_id, :meal_count, presence: true
    validates :meal_count, numericality: { greater_than: 0, less_than: 7, integer: true }

    enum status: [:enabled, :disabled]
    enum delivery_day: [:monday, :tuesday, :wednesday]

    def valid_meal_counts
      (1..6).to_a
    end

  end
end
