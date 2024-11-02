FactoryBot.define do
  factory :click do
    association :shortened_url
    association :geolocation, factory: :geolocation
  end
end
