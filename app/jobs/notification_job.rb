class NotificationJob < ApplicationJob
  queue_as :default

  def perform(environment_reading)
    text_message = TextMessage.new(environment_reading: environment_reading)
    response = text_message.save!
    parsed_response = JSON.parse(response.body)
    raise parsed_response.fetch('error') unless parsed_response.fetch('success')
  end
end
