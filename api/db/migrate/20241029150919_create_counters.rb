class CreateCounters < ActiveRecord::Migration[7.1]
  def change
    create_table :counters do |t|
      t.bigint :value, null: false, default: 0

      t.timestamps
    end
  end
end
