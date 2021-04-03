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
end
