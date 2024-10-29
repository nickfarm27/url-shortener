class InitializeCounter < ActiveRecord::Migration[7.1]
  def up
    unless Counter.exists?(id: 1)
      # in base 62, this is 1000000
      Counter.create!(id: 1, value: 56800235584)
    end
  end

  def down
    Counter.find_by(id: 1)&.destroy
  end
end
