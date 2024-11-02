FactoryBot.define do
  factory :geolocation do
    sequence(:ip_address) { |n| "192.168.1.#{n}" }
  end
end
