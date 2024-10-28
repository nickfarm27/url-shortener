class Geolocation < ApplicationRecord
  validates :ip_address, presence: true, ip_address: true, uniqueness: true

  before_validation :strip_whitespace

  def strip_whitespace
    self.ip_address = ip_address.strip
  end
end
