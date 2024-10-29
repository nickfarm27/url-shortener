class TrackClickJob < ApplicationJob
  queue_as :default

  def perform(shortened_url_id, redirected_at, ip_address)
    TrackClickService.call(shortened_url_id, redirected_at, ip_address)
  end
end
