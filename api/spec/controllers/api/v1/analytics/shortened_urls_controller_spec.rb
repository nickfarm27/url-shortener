# spec/controllers/api/v1/analytics/shortened_urls_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::Analytics::ShortenedUrlsController, type: :controller do
  let(:shortened_url) { create(:shortened_url) }

  shared_examples 'returns not found' do
    it 'returns not found status' do
      subject
      expect(response).to have_http_status(:not_found)
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq("Shortened URL with ID #{-1} not found")
    end
  end

  describe 'GET #total_clicks' do
    subject { get :total_clicks, params: { id: shortened_url_id } }

    context 'when shortened url exists' do
      let(:shortened_url_id) { shortened_url.id }
      let(:total_clicks) { 42 }
      let(:service_result) { OpenStruct.new(payload: total_clicks) }

      before do
        allow(Analytics::ShortenedUrl::TotalClicksRetrievalService)
          .to receive(:call)
          .with(shortened_url)
          .and_return(service_result)
      end

      it 'returns total clicks count' do
        subject
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['total_clicks']).to eq(total_clicks)
      end
    end

    context 'when shortened url does not exist' do
      let(:shortened_url_id) { -1 }
      it_behaves_like 'returns not found'
    end
  end

  describe 'GET #clicks_by_countries' do
    subject { get :clicks_by_countries, params: { id: shortened_url_id } }

    context 'when shortened url exists' do
      let(:shortened_url_id) { shortened_url.id }
      let(:countries_data) do
        [
          { country: 'US', count: 3 },
          { country: 'JP', count: 2 }
        ]
      end
      let(:service_result) { OpenStruct.new(payload: countries_data) }

      before do
        allow(Analytics::ShortenedUrl::CountriesClickCountRetrievalService)
          .to receive(:call)
          .with(shortened_url)
          .and_return(service_result)
      end

      it 'returns clicks count by countries' do
        subject
        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response['countries']).to eq(JSON.parse(countries_data.to_json))
      end
    end

    context 'when shortened url does not exist' do
      let(:shortened_url_id) { -1 }
      it_behaves_like 'returns not found'
    end
  end

  describe 'GET #clicks' do
    subject { get :clicks, params: { id: shortened_url_id } }

    context 'when shortened url exists' do
      let(:shortened_url_id) { shortened_url.id }
      let!(:clicks) { create_list(:click, 3, shortened_url: shortened_url) }

      before do
        allow(ClickSerializer).to receive(:render).and_return([{ id: 1 }, { id: 2 }, { id: 3 }])
      end

      it 'returns paginated clicks' do
        subject
        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['clicks'].length).to eq(3)
        expect(json_response['meta']).to include(
          'count',
          'page',
          'next',
          'prev',
        )
      end

      it 'uses click serializer' do
        expect(ClickSerializer).to receive(:render)
        subject
      end
    end

    context 'when shortened url does not exist' do
      let(:shortened_url_id) { -1 }
      it_behaves_like 'returns not found'
    end
  end
end
