# spec/services/analytics/shortened_url/countries_click_count_retrieval_service_spec.rb

require 'rails_helper'

RSpec.describe Analytics::ShortenedUrl::CountriesClickCountRetrievalService do
  let(:shortened_url) { create(:shortened_url) }
  let(:service) { described_class.new(shortened_url) }

  describe '#call' do
    before do
      Counter.create!(value: 56_800_235_584, name: "urls")
    end

    after do
      Counters::UrlCounter.instance_variable_set(:@instance, nil)
    end

    context 'when shortened_url is nil' do
      let(:service) { described_class.new(nil) }

      it 'returns failure result' do
        result = service.call
        expect(result.success?).to be false
        expect(result.errors[:shortened_url]).to include("can't be blank")
      end
    end

    context 'when shortened_url is valid' do
      before do
        Rails.cache.clear
      end

      context 'when there are no clicks' do
        it 'returns empty array' do
          result = service.call
          expect(result.success?).to be true
          expect(result.payload).to eq([])
        end
      end

      context 'when there are clicks' do
        let!(:us_geolocation) { create(:geolocation, country_code: 'US') }
        let!(:jp_geolocation) { create(:geolocation, country_code: 'JP') }
        let!(:unknown_geolocation) { create(:geolocation, country_code: nil) }

        before do
          # Create 3 clicks from US
          create_list(:click, 3, shortened_url: shortened_url, geolocation: us_geolocation)
          # Create 2 clicks from Japan
          create_list(:click, 2, shortened_url: shortened_url, geolocation: jp_geolocation)
          # Create 1 click with unknown location
          create(:click, shortened_url: shortened_url, geolocation: unknown_geolocation)
          # Create 1 click without geolocation
          create(:click, shortened_url: shortened_url, geolocation: nil)
        end

        it 'returns countries click count sorted by count in descending order' do
          result = service.call
          expect(result.success?).to be true
          expect(result.payload).to eq([
            { country: "United States", count: 3 },
            { country: "Japan", count: 2 },
            { country: nil, count: 2 }
          ])
        end

        it 'caches the result' do
          cached_result = [
            { country: "United States", count: 3 },
            { country: "Japan", count: 2 },
            { country: nil, count: 2 }
          ]

          expect(Rails.cache).to receive(:fetch)
            .with("analytics/countries_click_count/#{shortened_url.id}", expires_in: 5.minutes)
            .and_return(cached_result)

          result = service.call
          expect(result.payload).to eq(cached_result)
        end

        it 'expires cache after 5 minutes' do
          # Initial call and cache
          Rails.cache.write(
            "analytics/countries_click_count/#{shortened_url.id}",
            [
              { country: "United States", count: 3 },
              { country: "Japan", count: 2 },
              { country: nil, count: 2 }
            ],
            expires_in: 5.minutes
          )

          # Create new click
          create(:click, shortened_url: shortened_url, geolocation: us_geolocation)

          travel 6.minutes do
            result = service.call
            expect(result.payload.first).to eq({
              country: "United States",
              count: 4
            })
          end
        end

        context 'with clicks from different shortened_url' do
          let(:other_shortened_url) { create(:shortened_url) }

          before do
            create_list(:click, 5, shortened_url: other_shortened_url, geolocation: us_geolocation)
          end

          it 'only counts clicks for the specified shortened_url' do
            result = service.call
            us_count = result.payload.find { |c| c[:country] == "United States" }[:count]
            expect(us_count).to eq(3)
          end
        end
      end
    end
  end
end
