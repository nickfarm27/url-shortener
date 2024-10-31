class Api::V1::ShortenedUrlsController < ApplicationController
  def index
    pagy, records = pagy(ShortenedUrl.order(created_at: :desc))

    render json: { shortened_urls: records, meta: pagy }
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
end
