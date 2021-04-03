class IotJob < ApplicationJob
  queue_as :default

  def perform(message)
    data = JSON.parse(message)
    EnvironmentReading.create!(temperature: data.fetch('temperature'), humidity: data.fetch('humidity'))
  end
end
