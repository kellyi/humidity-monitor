require 'net/http'
require 'uri'

class TextMessage
  include ActiveModel::Model

  attr_accessor :environment_reading

  delegate :humidity, :temperature, :created_at, :message, :id, to: :environment_reading

  def save!
    send_message!
  end

  private

  def send_message!
    Net::HTTP.post_form(uri, request)
  end

  def request
    {
      phone: phone_number,
      message: text_message,
      key: api_key
    }
  end

  def text_message
    "#{message}. Humidity is #{humidity}. Temperature is #{temperature}."
  end

  def api_key
    ENV.fetch('TEXT_MESSAGE_API_KEY')
  end

  def phone_number
    ENV.fetch('TEXT_MESSAGE_PHONE_NUMBER')
  end

  def uri
    URI.parse(ENV.fetch('TEXT_MESSAGE_URI'))
  end
end
