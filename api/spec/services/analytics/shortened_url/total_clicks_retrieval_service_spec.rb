# spec/services/analytics/shortened_url/total_clicks_retrieval_service_spec.rb

require 'rails_helper'

RSpec.describe Analytics::ShortenedUrl::TotalClicksRetrievalService do
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
        it 'returns zero clicks' do
          result = service.call
          expect(result.success?).to be true
          expect(result.payload).to eq(0)
        end
      end

      context 'when there are clicks' do
        before do
          create_list(:click, 3, shortened_url: shortened_url)
        end

        it 'returns the correct number of clicks' do
          result = service.call
          expect(result.success?).to be true
          expect(result.payload).to eq(3)
        end

        it 'caches the result' do
          expect(Rails.cache).to receive(:fetch)
            .with("analytics/total_clicks/#{shortened_url.id}", expires_in: 5.minutes)
            .and_return(3)

          result = service.call
          expect(result.payload).to eq(3)
        end

        it 'expires cache after 5 minutes' do
          # Initial call and cache
          Rails.cache.write("analytics/total_clicks/#{shortened_url.id}", 3, expires_in: 5.minutes)

          # Create new click
          create(:click, shortened_url: shortened_url)

          travel 6.minutes do
            result = service.call
            expect(result.payload).to eq(4)
          end
        end
      end
    end
  end
end
