class ClickSerializer < Oj::Serializer
  attributes :id, :created_at

  attribute :country do
    country_code = click.geolocation&.country_code
    if country_code.present?
      ISO3166::Country.new(country_code).common_name
    end
  end
end
