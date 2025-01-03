class ShortenedUrl::TrackClickService < ApplicationService
  include ActiveModel::Validations

  validates :shortened_url, :redirected_at, presence: true

  def initialize(shortened_url_id, redirected_at, ip_address)
    @shortened_url = ShortenedUrl.find_by(id: shortened_url_id)
    @redirected_at = redirected_at
    @ip_address = ip_address&.strip
  end

  def call
    return result(success: false, errors: errors) if invalid?

    track_click
    purge_analytics_cache
    enqueue_search_geolocation_job

    result(success: errors.empty?, errors: errors)
  end

  private

  attr_reader :shortened_url, :ip_address, :redirected_at
  attr_accessor :click

  def geolocation
    return @geolocation if @geolocation || ip_address.blank?

    @geolocation = Geolocation.find_or_create_by!(ip_address: ip_address)
  rescue ActiveRecord::RecordInvalid
    nil
  rescue ActiveRecord::RecordNotUnique
    # If the create fails because the IP address is already in the database, it means that the IP address is created
    # in the split moment after the 'find' and before the 'create'.
    # We can try finding the IP address again to see if it's in the database.
    @geolocation = Geolocation.find_by(ip_address: ip_address)
  end

  def track_click
    self.click = Click.create!(
      shortened_url: shortened_url,
      created_at: redirected_at,
      geolocation: geolocation
    )
  rescue ActiveRecord::RecordInvalid => e
    errors.add(:base, e.record.errors.full_messages.join(", "))
  end

  def purge_analytics_cache
    return if click.blank?

    Analytics::ShortenedUrl::PurgeAnalyticsCacheService.call(shortened_url)
  end

  def enqueue_search_geolocation_job
    return if geolocation.blank? || geolocation.country_code.present?

    SearchGeolocationJob.perform_later(geolocation.id)
  end
end
