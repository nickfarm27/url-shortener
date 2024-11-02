# spec/jobs/search_geolocation_job_spec.rb

require 'rails_helper'

RSpec.describe SearchGeolocationJob, type: :job do
  describe '#perform' do
    let(:geolocation_id) { 1 }
    let(:service) { class_double(SearchGeolocationService).as_stubbed_const }
    let(:result) { instance_double('Result') }

    before do
      allow(service).to receive(:call).with(geolocation_id).and_return(result)
    end

    context 'when service call is successful' do
      before do
        allow(result).to receive(:success?).and_return(true)
      end

      it 'does not retry the job' do
        expect_any_instance_of(described_class).not_to receive(:retry_job)
        described_class.perform_now(geolocation_id)
      end
    end

    context 'when service call fails' do
      before do
        allow(result).to receive(:success?).and_return(false)
        allow(result).to receive(:payload).and_return(payload)
      end

      context 'with rate limit error (429)' do
        let(:payload) { { error_code: 429 } }

        it 'retries the job' do
          expect_any_instance_of(described_class).to receive(:retry_job).with(wait: 10.seconds)
          described_class.perform_now(geolocation_id)
        end
      end

      context 'with server error (5xx)' do
        let(:payload) { { error_code: 503 } }

        it 'retries the job' do
          expect_any_instance_of(described_class).to receive(:retry_job).with(wait: 10.seconds)
          described_class.perform_now(geolocation_id)
        end
      end

      context 'with other error code' do
        let(:payload) { { error_code: 400 } }

        it 'does not retry the job' do
          expect_any_instance_of(described_class).not_to receive(:retry_job)
          described_class.perform_now(geolocation_id)
        end
      end

      context 'with blank payload' do
        let(:payload) { nil }

        it 'does not retry the job' do
          expect_any_instance_of(described_class).not_to receive(:retry_job)
          described_class.perform_now(geolocation_id)
        end
      end
    end
  end
end
