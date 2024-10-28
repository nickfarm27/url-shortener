class Click < ApplicationRecord
  belongs_to :shortened_url
  belongs_to :geolocation, optional: true
end
