require 'rails_helper'

RSpec.describe NotificationJob, type: :job do
  before do
    ActiveJob::Base.queue_adapter = :test
    ENV['TEXT_MESSAGE_URI'] = 'https://example.org'
    ENV['TEXT_MESSAGE_API_KEY'] = 'ac6f2777-4f34-4630-a424-ceb86d09cc82'
    ENV['TEXT_MESSAGE_PHONE_NUMBER'] = '1234567788'
  end

  describe '#perform' do
    let!(:environment_reading) { FactoryBot.create(:environment_reading, humidity: 20) }

    subject { described_class }

    it 'sends a test message' do
      stub = stub_request(:post, "https://example.org/")
             .with(
               body: 'phone=1234567788&message=Not+humid+enough.+Humidity+is+20.0.+Temperature+is+40.0.&key=ac6f2777-4f34-4630-a424-ceb86d09cc82',
               headers: {
                 'Accept' => '*/*',
                 'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
                 'User-Agent' => 'Ruby'
               }
             )
             .to_return(status: 200, body: "{\"success\": true, \"error\": null}", headers: {})

      subject.perform_now(environment_reading)
      expect(stub).to have_been_requested.once
    end
  end
end
