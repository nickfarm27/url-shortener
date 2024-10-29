require "net/http"

class SearchGeolocationService < ApplicationService
  include ActiveModel::Validations

  validates :geolocation, presence: true
  validate :country_code_not_filled

  def initialize(geolocation_id)
    @geolocation = Geolocation.find_by(id: geolocation_id)
  end

  def call
    return result(success: false, errors: errors) if invalid?

    search_and_update_geolocation

    result(success: errors.empty?, errors: errors, payload: payload)
  end

  private

  attr_reader :geolocation
  attr_accessor :payload

  def country_code_not_filled
    errors.add(:base, "Country code already filled") if geolocation.country_code.present?
  end

  def search_and_update_geolocation
    uri = URI("https://api.country.is/#{geolocation.ip_address}")
    response = Net::HTTP.get_response(uri)
    response_body = JSON.parse(response.body)

    if response.is_a?(Net::HTTPSuccess)
      geolocation.update!(country_code: response_body["country"])
    else
      error_code = response_body["error"]["code"]

      self.payload = { error_code: error_code }
      errors.add(:base, "Error code #{error_code} received from the API")
    end
  end
end
