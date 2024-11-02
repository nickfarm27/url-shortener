FactoryBot.define do
  factory :shortened_url do
    target_url { "https://example.com" }
    sequence(:path) { |n| SecureRandom.alphanumeric(7) }
  end
end
