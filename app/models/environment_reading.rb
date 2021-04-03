class EnvironmentReading < ApplicationRecord
  MAX_HUMIDITY = 70
  MIN_HUMIDITY = 45

  after_save :notify

  scope :by_recency, -> { order(created_at: :desc) }

  def message
    # see https://eu.steinway.com/en/dealer/south-africa/service/caring-for-your-steinway/
    if too_humid?
      'Too humid'
    elsif not_humid_enough?
      'Not humid enough'
    else
      'Fine humidity'
    end
  end

  private

  def notify
    NotificationJob.perform_later(self) if notifiable?
  end

  def notifiable?
    too_humid? || not_humid_enough?
  end

  def too_humid?
    humidity > MAX_HUMIDITY
  end

  def not_humid_enough?
    humidity < MIN_HUMIDITY
  end
end
