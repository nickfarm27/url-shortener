class Analytics::ShortenedUrl::CountriesClickCountRetrievalService < ApplicationService
  include ActiveModel::Validations

  validates :shortened_url, presence: true

  def initialize(shortened_url)
    @shortened_url = shortened_url
  end

  def call
    return result(success: false, errors: errors) if invalid?

    result(success: true, payload: countries_click_count)
  end

  private

  attr_reader :shortened_url

  def countries_click_count
    Rails.cache.fetch("analytics/countries_click_count/#{shortened_url.id}", expires_in: 5.minutes) do
      Click.where(shortened_url: shortened_url).left_joins(:geolocation).group("geolocations.country_code").count.sort_by do |_country, count|
        -count
      end.map do |country_code, count|
        country = country_code.present? ? ISO3166::Country.new(country_code).common_name : nil
        { country:, count: }
      end
    end
  end
end
