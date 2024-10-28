class ShortenedUrl < ApplicationRecord
  validates :path, presence: true, uniqueness: true
  validates :target_url, presence: true

  has_many :clicks
end
