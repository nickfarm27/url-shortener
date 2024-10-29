class CreateCounters < ActiveRecord::Migration[7.1]
  def change
    create_table :counters do |t|
      t.bigint :value, null: false, default: 0
      t.string :name, null: false, index: { unique: true }

      t.timestamps
    end
  end
end
