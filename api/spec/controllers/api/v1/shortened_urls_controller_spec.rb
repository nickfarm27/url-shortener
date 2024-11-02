# spec/controllers/api/v1/shortened_urls_controller_spec.rb

require 'rails_helper'

RSpec.describe Api::V1::ShortenedUrlsController, type: :controller do
  describe 'GET #index' do
    let!(:shortened_urls) { create_list(:shortened_url, 3) }

    it 'returns a paginated list of shortened urls' do
      get :index

      expect(response).to have_http_status(:ok)

      json_response = JSON.parse(response.body)
      expect(json_response['shortened_urls'].length).to eq(3)
      expect(json_response['meta']).to include(
        'count',
        'page',
        'next',
        'prev',
      )
    end

    it 'returns shortened urls in descending order by creation date' do
      get :index

      json_response = JSON.parse(response.body)
      created_dates = json_response['shortened_urls'].map { |url| url['created_at'] }
      expect(created_dates).to eq(created_dates.sort.reverse)
    end
  end

  describe 'GET #show' do
    context 'when shortened url exists' do
      let(:shortened_url) { create(:shortened_url) }

      it 'returns the shortened url' do
        get :show, params: { id: shortened_url.id }

        expect(response).to have_http_status(:ok)

        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq(shortened_url.id)
        expect(json_response['target_url']).to eq(shortened_url.target_url)
        expect(json_response['path']).to eq(shortened_url.path)
      end
    end

    context 'when shortened url does not exist' do
      it 'returns not found status' do
        get :show, params: { id: -1 }

        expect(response).to have_http_status(:not_found)

        json_response = JSON.parse(response.body)
        expect(json_response['error']).to eq('Shortened URL not found')
      end
    end
  end

  describe 'POST #create' do
    let(:valid_params) { { target_url: 'https://example.com', title: 'Example' } }
    let(:invalid_params) { { target_url: 'invalid-url', title: 'Example' } }

    before do
      Counter.create!(value: 56_800_235_584, name: "urls")
    end

    after do
      Counters::UrlCounter.instance_variable_set(:@instance, nil)
    end

    context 'with valid parameters' do
      it 'creates a new shortened url' do
        expect {
          post :create, params: valid_params
        }.to change(ShortenedUrl, :count).by(1)

        expect(response).to have_http_status(:created)

        json_response = JSON.parse(response.body)
        expect(json_response['target_url']).to eq(valid_params[:target_url])
        expect(json_response['title']).to eq(valid_params[:title])
        expect(json_response['path']).to be_present
      end
    end

    context 'with invalid parameters' do
      it 'returns unprocessable entity status' do
        expect {
          post :create, params: invalid_params
        }.not_to change(ShortenedUrl, :count)

        expect(response).to have_http_status(:unprocessable_entity)

        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to be_present
      end
    end
  end
end
