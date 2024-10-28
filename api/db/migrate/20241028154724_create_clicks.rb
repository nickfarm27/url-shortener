class CreateClicks < ActiveRecord::Migration[7.1]
  def change
    create_table :clicks do |t|
      t.references :shortened_url, null: false, foreign_key: true
      t.string :ip_address
      t.string :country_code

      t.timestamps
    end
  end
end
