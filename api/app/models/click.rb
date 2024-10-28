class Click < ApplicationRecord
  belongs_to :shortened_url

  validates :ip_address, ip_address: true
end
