require 'rails_helper'

RSpec.describe MessageQuota do
  describe '#remaining_messages' do
    let(:mock_api_key) { '6e1eb433-b806-47e3-985b-1236de6db657' }
    let(:mock_quota_uri) { 'http://example.org' }

    before do
      ENV['TEXT_MESSAGE_API_KEY'] = mock_api_key
      ENV['TEXT_MESSAGE_QUOTA_URI'] = mock_quota_uri
    end

    subject { described_class.new }

    context 'when the env var are not configured' do
      let(:mock_api_key) { nil }
      let(:mock_quota_uri) { nil }

      it 'raises an error' do
        expect { subject.remaining_messages }.to raise_error(KeyError)
      end
    end

    context 'when the env var are configured' do
      let(:mock_api_key) { '6e1eb433-b806-47e3-985b-1236de6db657' }
      let(:mock_quota_uri) { 'http://example.org' }

      it 'returns the count of remaining messages' do
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

        expect(subject.remaining_messages).to eq 1234
        expect(stub).to have_been_requested.once
      end
    end
  end
end
