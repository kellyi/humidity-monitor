require 'rails_helper'

RSpec.describe MessagesController do
  describe 'GET /messages' do
    let(:mock_api_key) { '6e1eb433-b806-47e3-985b-1236de6db657' }
    let(:mock_quota_uri) { 'http://example.org' }

    before do
      ENV['TEXT_MESSAGE_API_KEY'] = mock_api_key
      ENV['TEXT_MESSAGE_QUOTA_URI'] = mock_quota_uri
    end

    it 'renders a count of remaining messages' do
      stub = stub_request(:get, "http://example.org/6e1eb433-b806-47e3-985b-1236de6db657")
             .with(
               headers: {
                 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'Host' => 'example.org',
                 'User-Agent' => 'Ruby'
               }
             )
             .to_return(status: 200, body: "{\"success\": true, \"quotaRemaining\": 1234}", headers: {})

      get('/messages')
      expect(stub).to have_been_requested.once
      expect(response.body).to include('There are 1234 remaining messages.')
    end
  end
end
