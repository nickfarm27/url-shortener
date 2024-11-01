class Analytics::ShortenedUrl::TotalClicksRetrievalService < ApplicationService
  include ActiveModel::Validations

  validates :shortened_url, presence: true

  def initialize(shortened_url)
    @shortened_url = shortened_url
  end

  def call
    return result(success: false, errors: errors) if invalid?

    result(success: true, payload: total_clicks)
  end

  private

  attr_reader :shortened_url

  def total_clicks
    Rails.cache.fetch("analytics/total_clicks/#{shortened_url.id}", expires_in: 5.minutes) do
      Click.where(shortened_url: shortened_url).count
    end
  end
end
