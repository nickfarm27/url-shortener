# spec/controllers/api/v1/shortened_paths_controller_spec.rb

require "rails_helper"

RSpec.describe Api::V1::ShortenedPathsController, type: :controller do
  describe "GET #redirect" do
    let(:ip_address) { "192.168.1.1" }
    let(:shortened_url) { create(:shortened_url) }
    let(:params) { { shortened_path: shortened_url.path, ip_address: ip_address } }

    context "when shortened path exists" do
      before do
        Rails.cache.clear
      end

      it "returns the target url" do
        get :redirect, params: params

        expect(response).to have_http_status(:ok)
        json_response = JSON.parse(response.body)
        expect(json_response["target_url"]).to eq(shortened_url.target_url)
      end

      it "enqueues track click job" do
        freeze_time do
          expect(ShortenedUrl::TrackClickJob).to receive(:perform_later)
            .with(shortened_url.id, Time.zone.now, ip_address)

          get :redirect, params: params
        end
      end

      context "with caching" do
        it "fetches from cache on subsequent requests" do
          cached_data = {
            id: shortened_url.id,
            target_url: shortened_url.target_url
          }

          # Manually set the cache
          Rails.cache.write("shortened_url/#{shortened_url.path}", cached_data)

          # Update the record
          shortened_url.update!(target_url: "https://newurl.com")

          # Request should use cached data
          get :redirect, params: params

          json_response = JSON.parse(response.body)
          expect(json_response["target_url"]).to eq(shortened_url.target_url_was)
        end
      end
    end

    context "when shortened path does not exist" do
      let(:params) { { shortened_path: "nonexistent", ip_address: ip_address } }

      it "returns not found status" do
        get :redirect, params: params

        expect(response).to have_http_status(:not_found)
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to include("Shortened path not found")
      end

      it "does not enqueue track click job" do
        expect(ShortenedUrl::TrackClickJob).not_to receive(:perform_later)

        get :redirect, params: params
      end
    end

    context "when ip_address is not provided" do
      let(:params) { { shortened_path: shortened_url.path } }

      it "enqueues track click job with nil ip_address" do
        freeze_time do
          expect(ShortenedUrl::TrackClickJob).to receive(:perform_later)
            .with(shortened_url.id, Time.zone.now, nil)

          get :redirect, params: params
        end
      end
    end
  end
end
