# spec/services/search_geolocation_service_spec.rb

require 'rails_helper'

RSpec.describe SearchGeolocationService do
  let(:ip_address) { "192.168.1.1" }
  let(:country_code) { nil }
  let(:geolocation) { Geolocation.create!(ip_address: ip_address, country_code: country_code) }
  let(:service) { described_class.new(geolocation.id) }

  describe '#call' do
    context 'when geolocation is not found' do
      let(:service) { described_class.new(-1) }

      it 'returns failure result' do
        result = service.call
        expect(result.success?).to be false
        expect(result.errors[:geolocation]).to include("can't be blank")
      end
    end

    context 'when country_code is already present' do
      let(:country_code) { 'US' }

      it 'returns failure result' do
        result = service.call
        expect(result.success?).to be false
        expect(result.errors[:base]).to include("Country code already filled")
      end
    end

    context 'when making API request' do
      let(:uri) { URI("https://api.country.is/#{ip_address}") }
      let(:response) { instance_double(Net::HTTPResponse) }
      let(:response_body) { {} }

      before do
        allow(Net::HTTP).to receive(:get_response).with(uri).and_return(response)
        allow(response).to receive(:body).and_return(response_body.to_json)
      end

      context 'when API request is successful' do
        let(:response_body) { { "country" => "US" } }

        before do
          allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(true)
        end

        it 'updates geolocation with country code' do
          result = service.call
          expect(result.success?).to be true
          expect(geolocation.reload.country_code).to eq("US")
        end
      end

      context 'when API request fails' do
        let(:response_body) { { "error" => { "code" => 429 } } }

        before do
          allow(response).to receive(:is_a?).with(Net::HTTPSuccess).and_return(false)
        end

        it 'returns failure result with error code' do
          result = service.call
          expect(result.success?).to be false
          expect(result.errors[:base]).to include("Error code 429 received from the API")
          expect(result.payload).to eq({ error_code: 429 })
        end
      end

      context 'when API request raises error' do
        before do
          allow(Net::HTTP).to receive(:get_response).and_raise(StandardError.new("API Error"))
        end

        it 'raises the error' do
          expect { service.call }.to raise_error(StandardError, "API Error")
        end
      end
    end
  end
end
