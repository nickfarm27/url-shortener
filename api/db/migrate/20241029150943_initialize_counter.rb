class InitializeCounter < ActiveRecord::Migration[7.1]
  def up
    return if Counter.exists?(name: "urls")

    # in base 62, this is 1000000
    Counter.create!(value: 56_800_235_584, name: "urls")
  end

  def down
    Counter.find_by(name: "urls")&.destroy!
  end
end
