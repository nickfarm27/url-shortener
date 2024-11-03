class Api::V1::ShortenedUrlsController < ApplicationController
  def index
    pagy, records = pagy(ShortenedUrl.order(created_at: :desc))

    render json: { shortened_urls: records, meta: pagy }
  end

  def show
    if shortened_url.blank?
      render json: { error: "Shortened URL not found" }, status: :not_found
    else
      render json: shortened_url
    end
  end

  def create
    shortened_url = ShortenedUrl.create!(permitted_params)

    render json: shortened_url, status: :created
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  private

  def permitted_params
    params.permit(:target_url, :title)
  end

  def shortened_url_id
    params[:id]
  end

  def shortened_url
    @shortened_url ||= fetch_from_cache || fetch_from_database
  end

  def fetch_from_cache
    Rails.cache.read("shortened_url/#{shortened_url_id}", expires_in: 5.minutes)
  end

  def fetch_from_database
    shortened_url_record = ShortenedUrl.find_by(id: shortened_url_id)
    return nil if shortened_url_record.blank?

    shortened_url_hash = shortened_url_record.attributes
    Rails.cache.write("shortened_url/#{shortened_url_id}", shortened_url_hash)
    shortened_url_hash
  end
end
