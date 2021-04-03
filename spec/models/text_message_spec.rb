require 'rails_helper'

RSpec.describe TextMessage do
  describe '#save!' do
    let(:temperature) { 20 }
    let(:humidity) { 50 }
    let!(:environment_reading) { FactoryBot.create(:environment_reading, humidity: humidity, temperature: temperature) }
    let(:mock_uri) { nil }
    let(:mock_api_key) { nil }
    let(:mock_phone_number) { nil }

    before do
      ENV['TEXT_MESSAGE_URI'] = mock_uri
      ENV['TEXT_MESSAGE_API_KEY'] = mock_api_key
      ENV['TEXT_MESSAGE_PHONE_NUMBER'] = mock_phone_number
    end

    subject { described_class.new(environment_reading: environment_reading) }

    context 'when the environment variables are unset' do
      let(:mock_uri) { nil }
      let(:mock_api_key) { nil }
      let(:mock_phone_number) { nil }

      context 'when the humidity is below 45' do
        it 'raises an error' do
          expect { subject.save! }.to raise_error(KeyError)
        end
      end

      context 'when the humidity is above 70' do
        it 'raises an error' do
          expect { subject.save! }.to raise_error(KeyError)
        end
      end
    end

    context 'when the environment variables are set' do
      let(:mock_uri) { 'https://example.org' }
      let(:mock_api_key) { '08aa33db-09ee-42fb-b988-6c1a7b1a14af' }
      let(:mock_phone_number) { '1234567788' }

      let(:headers) do
        {
          'Accept' => '*/*',
          'Accept-Encoding' => 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          'User-Agent' => 'Ruby'
        }
      end

      context 'when the humidity is below 45' do
        let(:message) { 'Not humid enough' }
        let(:humidity) { 20 }
        let(:expected_body) do
          'phone=1234567788&message=Not+humid+enough.+Humidity+is+20.0.+Temperature+is+20.0.&key=08aa33db-09ee-42fb-b988-6c1a7b1a14af'
        end

        it 'sends a message about the humidity being too low' do
          stub = stub_request(:post, mock_uri)
                 .with(body: expected_body, headers: headers)
                 .to_return(status: 200, body: '', headers: {})

          subject.save!
          expect(stub).to have_been_requested.once
        end
      end

      context 'when the humidity is above 70' do
        let(:message) { 'Too humid' }
        let(:humidity) { 90 }
        let(:expected_body) do
          'phone=1234567788&message=Too+humid.+Humidity+is+90.0.+Temperature+is+20.0.&key=08aa33db-09ee-42fb-b988-6c1a7b1a14af'
        end

        it 'sends a message about the humidity being too high' do
          stub = stub_request(:post, mock_uri)
                 .with(body: expected_body, headers: headers)
                 .to_return(status: 200, body: '', headers: {})

          subject.save!
          expect(stub).to have_been_requested.once
        end
      end
    end
  end
end
