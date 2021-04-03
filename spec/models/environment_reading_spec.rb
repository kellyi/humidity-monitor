require "rails_helper"

RSpec.describe EnvironmentReading do
  describe 'scopes' do
    describe '.by_recency' do
      let!(:yesterdays_reading) { FactoryBot.create(:environment_reading, created_at: Time.zone.now - 1.day) }
      let!(:todays_reading) { FactoryBot.create(:environment_reading, created_at: Time.zone.now) }

      subject { described_class }

      it 'returns environment readings ordered by recency' do
        expect(subject.by_recency.first).to eq todays_reading
        expect(subject.by_recency.last).to eq yesterdays_reading
      end
    end
  end

  describe '#message' do
    let(:temperature) { 25 }
    let(:humidity) { nil }

    subject { described_class.new(humidity: humidity, temperature: temperature) }

    context 'when the humidity is below 45' do
      let(:humidity) { 20 }

      it 'returns Not humid enough' do
        expect(subject.message).to eq 'Not humid enough'
      end
    end

    context 'when the humidity is above 70' do
      let(:humidity) { 85 }

      it 'returns Too humid' do
        expect(subject.message).to eq 'Too humid'
      end
    end

    context 'when the humidity is between 45 and 70' do
      let(:humidity) { 50 }

      it 'returns Fine humidity' do
        expect(subject.message).to eq 'Fine humidity'
      end
    end
  end

  describe '#save' do
    let(:temperature) { 30 }
    let(:humidity) { 50 }

    before { ActiveJob::Base.queue_adapter = :test }

    subject { described_class.new(temperature: temperature, humidity: humidity) }

    context 'when the humidity is below 45' do
      let(:humidity) { 20 }

      it 'enqueues a notification job' do
        expect { subject.save }.to have_enqueued_job(NotificationJob)
      end
    end

    context 'when the humidity is above 70' do
      let(:humidity) { 85 }

      it 'enqueues a notification job' do
        expect { subject.save }.to have_enqueued_job(NotificationJob)
      end
    end

    context 'when the humidity is between 45 and 70' do
      let(:humidity) { 55 }

      it 'does not enqueue a notification job' do
        expect { subject.save }.not_to have_enqueued_job(NotificationJob)
      end
    end
  end
end
