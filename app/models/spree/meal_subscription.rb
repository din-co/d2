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

    statuses.each do |status, status_id|
      scope status.to_sym, -> { where(status: status_id) }
    end

    delivery_days.each do |delivery_day, day_id|
      scope delivery_day.to_sym, -> { where(delivery_day: day_id).active }
    end

    def valid_meal_counts
      self.class.valid_meal_counts
    end

    def self.notification_lead_time_days
      7
    end

    def self.order_lead_time_days
      5
    end

    def self.order_open_days
      notification_lead_time_days - order_lead_time_days
    end

    def order_processed_weekday
      Time.now.next_week(delivery_day.to_sym).advance(days: self.class.order_open_days).strftime("%A")
    end

    def notification_channels
      channels = []
      channels.push("text message") if notification_sms
      channels.push("email") if notification_email
      channels
    end

    def valid_notifications
      unless notification_sms || notification_email
        errors.add(:base, "You must select at least one notification method.")
      end
    end
  end
end
