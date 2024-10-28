class Geolocation < ApplicationRecord
  validates :ip_address, presence: true, ip_address: true, uniqueness: true
end
