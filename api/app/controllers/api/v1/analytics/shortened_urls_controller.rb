class Api::V1::Analytics::ShortenedUrlsController < ApplicationController
  before_action :set_shortened_url

  def total_clicks
    total_clicks = Analytics::ShortenedUrl::TotalClicksRetrievalService.call(@shortened_url).payload

    render json: { total_clicks: }
  end

  def clicks_by_countries
    countries = Analytics::ShortenedUrl::CountriesClickCountRetrievalService.call(@shortened_url).payload

    render json: { countries: countries }
  end

  def clicks
    pagy, records = pagy(clicks_query.order(created_at: :desc))

    render json: { clicks: ::ClickSerializer.render(records), meta: pagy }
  end

  private

  def shortened_url_id
    params[:id]
  end

  def set_shortened_url
    @shortened_url = ShortenedUrl.find_by(id: shortened_url_id)

    return unless @shortened_url.blank?

    render json: { error: "Shortened URL with ID #{shortened_url_id} not found" }, status: :not_found
  end

  def clicks_query
    @clicks_query ||= Click.where(shortened_url: @shortened_url).left_joins(:geolocation)
  end
end
