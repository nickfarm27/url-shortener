require 'rails_helper'

RSpec.describe Click, type: :model do
  describe 'associations' do
    it { should belong_to(:shortened_url) }
    it { should belong_to(:geolocation).optional }
  end

  describe 'creation' do
    let(:shortened_url) { ShortenedUrl.create!(target_url: 'https://example.com', path: 'abc123') }
    let(:geolocation) { Geolocation.create!(ip_address: '192.168.1.1') }

    it 'can be created with valid attributes' do
      click = Click.new(shortened_url: shortened_url)
      expect(click).to be_valid
    end

    it 'can be created with an optional geolocation' do
      click = Click.new(shortened_url: shortened_url, geolocation: geolocation)
      expect(click).to be_valid
    end

    it 'is invalid without a shortened_url' do
      click = Click.new(geolocation: geolocation)
      expect(click).not_to be_valid
    end
  end
end
