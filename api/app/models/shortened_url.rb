class ShortenedUrl < ApplicationRecord
  validates :path, presence: true, uniqueness: true
  validates :target_url, presence: true, url: true

  has_many :clicks, dependent: :destroy
end
