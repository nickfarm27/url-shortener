class CreateShortenedUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :shortened_urls do |t|
      t.string :path, null: false, index: { unique: true }
      t.string :target_url, null: false
      t.string :title

      t.timestamps
    end
  end
end
