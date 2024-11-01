class Api::V1::ShortenedPathsController < ApplicationController
  def redirect
    if shortened_url.present?
      ShortenedUrl::TrackClickJob.perform_later(shortened_url[:id], Time.zone.now, ip_address)

      render json: { target_url: shortened_url[:target_url] }, status: :ok
    else
      render json: { errors: ["Shortened path not found"] }, status: :not_found
    end
  end

  private

  def shortened_path
    params[:shortened_path]
  end

  def ip_address
    params[:ip_address]
  end

  def shortened_url
    @shortened_url ||= fetch_from_cache || fetch_from_database
  end

  def fetch_from_cache
    Rails.cache.read("shortened_url/#{shortened_path}")
  end

  def fetch_from_database
    shortened_url_record = ShortenedUrl.find_by(path: shortened_path)
    return nil if shortened_url_record.blank?

    shortened_url_hash = {
      id: shortened_url_record.id,
      target_url: shortened_url_record.target_url,
    }

    Rails.cache.write("shortened_url/#{shortened_path}", shortened_url_hash)
    shortened_url_hash
  end
end
