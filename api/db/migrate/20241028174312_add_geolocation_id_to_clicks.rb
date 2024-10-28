class AddGeolocationIdToClicks < ActiveRecord::Migration[7.1]
  def change
    add_reference :clicks, :geolocation, foreign_key: true
  end
end
