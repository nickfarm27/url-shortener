class CreateGeolocations < ActiveRecord::Migration[7.1]
  def change
    create_table :geolocations do |t|
      t.string :ip_address, null: false, index: { unique: true }
      t.string :country_code

      t.timestamps
    end
  end
end
