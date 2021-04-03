require 'rails_helper'

RSpec.describe IotJob, type: :job do
  describe '#perform' do
    before { ActiveJob::Base.queue_adapter = :test }

    subject { described_class }

    context 'when the data is malformed' do
      let(:message) { 'hello_world' }

      it 'raises an error' do
        expect { subject.perform_now(message) }.to raise_error(JSON::ParserError)
      end
    end

    context 'when the data is correctly formed' do
      let(:humidity) { 50 }

      let(:message) do
        { temperature: 20, humidity: humidity }.to_json
      end

      context 'when the humidity reading is not between 45 and 70' do
        let(:humidity) { 10 }

        it 'creates an EnvironmentReading and does enqueues a NotificaionJob' do
          expect { subject.perform_now(message) }
            .to change { EnvironmentReading.count }.from(0).to(1)
            .and have_enqueued_job(NotificationJob)
        end
      end

      context 'when the humidity reading is between 45 and 70' do
        let(:humidity) { 50 }

        it 'creates an EnvironmentReading without enqueueing a NotificationJob' do
          expect { subject.perform_now(message) }
            .to change { EnvironmentReading.count }.from(0).to(1)
            .and have_enqueued_job(NotificationJob).exactly(0).times
        end
      end
    end
  end
end
