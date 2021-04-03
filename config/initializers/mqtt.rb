require 'mqtt'

Thread.new do
  MQTT::Client.connect(host: ENV.fetch('MQTT_URL'), username: ENV.fetch('MQTT_USERNAME')) do |c|
    c.get(ENV.fetch('MQTT_TOPIC')) do |_topic, message|
      IotJob.perform_later(message)
    end
  end
rescue # mqtt is not configured, so application will not be able to receive reading data
end
