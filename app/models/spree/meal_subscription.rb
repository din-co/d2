module Spree
  class MealSubscription < Spree::Base
    belongs_to :user, class_name: Spree::UserClassHandle.new
    belongs_to :delivery_window

    def self.valid_meal_counts
      @valid_meal_counts ||= (2..6).to_a
    end

    validates :user_id, :status, :delivery_day, :delivery_window_id, :meal_count, presence: true
    validates :meal_count, numericality: { greater_than_or_equal_to: valid_meal_counts.first, less_than_or_equal_to: valid_meal_counts.last, only_integer: true }
    validate :valid_notifications

    enum status: [:active, :paused]
    enum delivery_day: {monday: 1, tuesday: 2, wednesday: 3}

    def valid_meal_counts
      self.class.valid_meal_counts
    end

    def self.notification_lead_time_days
      7
    end

    def self.order_lead_time_days
      5
    end

    def valid_notifications
      unless notification_sms || notification_email
        errors.add(:base, "You must select at least one notification method.")
      end
    end
  end
end
