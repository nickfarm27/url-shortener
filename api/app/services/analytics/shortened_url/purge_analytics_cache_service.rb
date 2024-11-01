class Analytics::ShortenedUrl::PurgeAnalyticsCacheService < ApplicationService
  include ActiveModel::Validations

  validates :shortened_url, presence: true

  def initialize(shortened_url)
    @shortened_url = shortened_url
  end

  def call
    return result(success: false, errors: errors) if invalid?

    result(success: true, payload: purged)
  end

  private

  attr_reader :shortened_url

  def shortened_url_id
    shortened_url.id
  end

  def purged
    Rails.cache.delete("analytics/total_clicks/#{shortened_url_id}")
    Rails.cache.delete("analytics/countries_click_count/#{shortened_url_id}")
  end
end
