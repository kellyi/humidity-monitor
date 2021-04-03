require 'net/http'
require 'uri'

class MessageQuota
  def remaining_messages
    JSON.parse(Net::HTTP.get(quota_uri)).fetch('quotaRemaining')
  end

  private

  def quota_uri
    URI.parse("#{uri}/#{api_key}")
  end

  def api_key
    ENV.fetch('TEXT_MESSAGE_API_KEY')
  end

  def uri
    ENV.fetch('TEXT_MESSAGE_QUOTA_URI')
  end
end
