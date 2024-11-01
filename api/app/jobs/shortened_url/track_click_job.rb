class ShortenedUrl::TrackClickJob < ApplicationJob
  queue_as :default

  def perform(shortened_url_id, redirected_at, ip_address)
    ShortenedUrl::TrackClickService.call(shortened_url_id, redirected_at, ip_address)
  end
end
