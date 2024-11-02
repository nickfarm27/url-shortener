require "rails_helper"

RSpec.describe Counter, type: :model do
  describe "validations" do
    subject { Counter.new(name: "test_counter", value: 0) }

    it { should validate_presence_of(:value) }

    it {
      should validate_numericality_of(:value)
        .only_integer
        .is_greater_than_or_equal_to(0)
    }
  end

  describe "value validation" do
    it "is valid with a positive integer" do
      counter = Counter.new(name: "test", value: 42)
      expect(counter).to be_valid
    end

    it "is valid with zero" do
      counter = Counter.new(name: "test", value: 0)
      expect(counter).to be_valid
    end

    it "is invalid with a negative number" do
      counter = Counter.new(name: "test", value: -1)
      expect(counter).to_not be_valid
    end

    it "is invalid with a decimal number" do
      counter = Counter.new(name: "test", value: 1.5)
      expect(counter).to_not be_valid
    end
  end
end
