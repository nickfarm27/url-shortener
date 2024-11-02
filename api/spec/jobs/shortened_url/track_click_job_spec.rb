require 'rails_helper'

RSpec.describe ShortenedUrl::TrackClickJob, type: :job do
  describe '#perform' do
    let(:shortened_url) { ShortenedUrl.create!(target_url: 'https://example.com', path: 'abc123') }
    let(:redirected_at) { Time.current }
    let(:ip_address) { '192.168.1.1' }

    it 'calls the TrackClickService with the correct parameters' do
      expect(ShortenedUrl::TrackClickService).to receive(:call)
        .with(shortened_url.id, redirected_at, ip_address)
        .once

      described_class.perform_now(shortened_url.id, redirected_at, ip_address)
    end

    it 'is enqueued with the correct arguments' do
      expect {
        described_class.perform_later(shortened_url.id, redirected_at, ip_address)
      }.to have_enqueued_job(described_class)
        .with(shortened_url.id, redirected_at, ip_address)
        .on_queue('default')
    end

    context 'when shortened_url does not exist' do
      it 'does not raise an error when job is performed' do
        expect {
          described_class.perform_now(-1, redirected_at, ip_address)
        }.not_to raise_error
      end
    end
  end
end
