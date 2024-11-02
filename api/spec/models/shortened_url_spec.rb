require "rails_helper"

RSpec.describe ShortenedUrl, type: :model do
  describe "validations" do
    subject { ShortenedUrl.new(target_url: "https://example.com", path: "abc123") }

    it { should validate_uniqueness_of(:path) }
    it { should validate_presence_of(:target_url) }

    context "target_url format" do
      it "is valid with a valid URL" do
        url = ShortenedUrl.new(target_url: "https://example.com", path: "abc123")
        expect(url).to be_valid
      end

      it "is invalid with an invalid URL" do
        url = ShortenedUrl.new(target_url: "invalid-url", path: "abc123")
        expect(url).to_not be_valid
      end
    end
  end

  describe "associations" do
    it { should have_many(:clicks).dependent(:destroy) }
  end

  describe "callbacks" do
    describe "#generate_path" do
      let(:url) { ShortenedUrl.new(target_url: "https://example.com") }

      context "when path is not provided" do
        before do
          Counter.create!(value: 56_800_235_584, name: "urls")
        end

        it "generates a path" do
          expect(url.path).to be_nil
          url.valid?
          expect(url.path).to be_present
        end
      end

      context "when path is provided" do
        it "does not generate a path" do
          url = ShortenedUrl.new(target_url: "https://example.com", path: "custom-path")
          url.valid?
          expect(url.path).to eq("custom-path")
        end
      end
    end
  end

  describe "#to_base62" do
    let(:url) { ShortenedUrl.new(target_url: "https://example.com") }

    it 'converts 0 to "0"' do
      expect(url.send(:to_base62, 0)).to eq("0")
    end

    it "converts positive numbers to base62 strings" do
      expect(url.send(:to_base62, 1)).to eq("1")
      expect(url.send(:to_base62, 10)).to eq("A")
      expect(url.send(:to_base62, 61)).to eq("z")
      expect(url.send(:to_base62, 62)).to eq("10")
      expect(url.send(:to_base62, 1000)).to match("G8")
    end
  end
end
