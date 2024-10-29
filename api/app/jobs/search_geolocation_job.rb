class SearchGeolocationJob < ApplicationJob
  queue_as :default

  def perform(geolocation_id)
    result = SearchGeolocationService.call(geolocation_id)

    return if result.success? || result.payload.blank?

    error_code = result.payload[:error_code]
    should_retry = error_code == 429 || error_code === (500..599)

    retry_job(wait: 10.seconds) if should_retry && executions < 5
  end
end
