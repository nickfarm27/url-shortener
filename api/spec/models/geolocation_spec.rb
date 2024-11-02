require "rails_helper"

RSpec.describe Geolocation, type: :model do
  describe "validations" do
    subject { Geolocation.new(ip_address: "2001:db8:85a3:8d3:1319:8a2e:370:7348") }

    it { should validate_presence_of(:ip_address) }
    it { should validate_uniqueness_of(:ip_address) }

    context "ip_address format" do
      it "is valid with a valid IP address" do
        geolocation = Geolocation.new(ip_address: "192.168.1.1")
        expect(geolocation).to be_valid
      end

      it "is invalid with an invalid IP address" do
        geolocation = Geolocation.new(ip_address: "invalid_ip")
        expect(geolocation).to_not be_valid
      end
    end
  end

  describe "callbacks" do
    describe "#strip_whitespace" do
      it "removes leading and trailing whitespace from ip_address" do
        geolocation = Geolocation.new(ip_address: "  192.168.1.1  ")
        geolocation.valid? # Trigger the callback
        expect(geolocation.ip_address).to eq("192.168.1.1")
      end
    end
  end
end
