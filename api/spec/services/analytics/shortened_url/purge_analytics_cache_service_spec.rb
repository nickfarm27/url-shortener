# spec/services/analytics/shortened_url/purge_analytics_cache_service_spec.rb

require 'rails_helper'

RSpec.describe Analytics::ShortenedUrl::PurgeAnalyticsCacheService do
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
      let(:total_clicks_cache_key) { "analytics/total_clicks/#{shortened_url.id}" }
      let(:countries_click_count_cache_key) { "analytics/countries_click_count/#{shortened_url.id}" }

      before do
        # Set up some cached data
        Rails.cache.write(total_clicks_cache_key, 42)
        Rails.cache.write(countries_click_count_cache_key, [{ country: "US", count: 42 }])
      end

      it 'purges all analytics cache for the shortened_url' do
        expect(Rails.cache).to receive(:delete).with(total_clicks_cache_key)
        expect(Rails.cache).to receive(:delete).with(countries_click_count_cache_key)

        result = service.call
        expect(result.success?).to be true
      end

      it 'actually removes the cached data' do
        service.call

        expect(Rails.cache.read(total_clicks_cache_key)).to be_nil
        expect(Rails.cache.read(countries_click_count_cache_key)).to be_nil
      end
    end
  end
end
