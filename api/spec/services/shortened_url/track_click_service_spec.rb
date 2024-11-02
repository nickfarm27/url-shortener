# spec/services/shortened_url/track_click_service_spec.rb

require 'rails_helper'

RSpec.describe ShortenedUrl::TrackClickService do
  let(:shortened_url) { create(:shortened_url) }
  let(:redirected_at) { Time.current }
  let(:ip_address) { "192.168.1.1" }
  let(:service) { described_class.new(shortened_url.id, redirected_at, ip_address) }

  describe '#call' do
    before do
      Counter.create!(value: 56_800_235_584, name: "urls")
    end

    after do
      Counters::UrlCounter.instance_variable_set(:@instance, nil)
    end

    context 'with invalid parameters' do
      context 'when shortened_url is not found' do
        let(:service) { described_class.new(-1, redirected_at, ip_address) }

        it 'returns failure result' do
          result = service.call
          expect(result.success?).to be false
          expect(result.errors[:shortened_url]).to include("can't be blank")
        end
      end

      context 'when redirected_at is nil' do
        let(:service) { described_class.new(shortened_url.id, nil, ip_address) }

        it 'returns failure result' do
          result = service.call
          expect(result.success?).to be false
          expect(result.errors[:redirected_at]).to include("can't be blank")
        end
      end
    end

    context 'with valid parameters' do
      let(:purge_service) { class_double(Analytics::ShortenedUrl::PurgeAnalyticsCacheService).as_stubbed_const }

      before do
        allow(purge_service).to receive(:call)
      end

      context 'when ip_address is blank' do
        let(:ip_address) { nil }

        it 'creates click without geolocation' do
          expect {
            result = service.call
            expect(result.success?).to be true
          }.to change(Click, :count).by(1)

          click = Click.last
          expect(click.shortened_url).to eq(shortened_url)
          expect(click.created_at).to eq(redirected_at)
          expect(click.geolocation).to be_nil
        end

        it 'purges analytics cache' do
          service.call
          expect(purge_service).to have_received(:call).with(shortened_url)
        end

        it 'does not enqueue geolocation job' do
          expect(SearchGeolocationJob).not_to receive(:perform_later)
          service.call
        end
      end

      context 'when ip_address is present' do
        context 'when geolocation does not exist' do
          it 'creates click with new geolocation' do
            expect {
              expect {
                result = service.call
                expect(result.success?).to be true
              }.to change(Click, :count).by(1)
            }.to change(Geolocation, :count).by(1)

            click = Click.last
            expect(click.shortened_url).to eq(shortened_url)
            expect(click.created_at).to eq(redirected_at)
            expect(click.geolocation.ip_address).to eq(ip_address)
          end

          it 'enqueues geolocation job' do
            expect(SearchGeolocationJob).to receive(:perform_later)
            service.call
          end
        end

        context 'when geolocation already exists' do
          let!(:existing_geolocation) { create(:geolocation, ip_address: ip_address) }

          it 'creates click with existing geolocation' do
            expect {
              expect {
                result = service.call
                expect(result.success?).to be true
              }.to change(Click, :count).by(1)
            }.not_to change(Geolocation, :count)

            click = Click.last
            expect(click.geolocation).to eq(existing_geolocation)
          end

          context 'when country_code is already present' do
            let!(:existing_geolocation) { create(:geolocation, ip_address: ip_address, country_code: 'US') }

            it 'does not enqueue geolocation job' do
              expect(SearchGeolocationJob).not_to receive(:perform_later)
              service.call
            end
          end
        end

        context 'when race condition occurs during geolocation creation' do
          let!(:existing_geolocation) { create(:geolocation, ip_address: ip_address) }

          before do
            allow(Geolocation).to receive(:find_or_create_by!)
              .and_raise(ActiveRecord::RecordNotUnique)
          end

          it 'handles the race condition and creates click' do
            expect {
              result = service.call
              expect(result.success?).to be true
            }.to change(Click, :count).by(1)

            click = Click.last
            expect(click.geolocation).to eq(existing_geolocation)
          end
        end
      end

      context 'when click creation fails' do
        before do
          allow(Click).to receive(:create!).and_raise(ActiveRecord::RecordInvalid.new(Click.new))
        end

        it 'returns failure result' do
          result = service.call
          expect(result.success?).to be false
          expect(result.errors[:base]).to be_present
        end
      end
    end
  end
end
