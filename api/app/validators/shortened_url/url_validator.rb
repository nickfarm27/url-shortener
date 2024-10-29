class ShortenedUrl::UrlValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    uri = parse_uri(value)

    return record.errors.add(attribute, "is not a valid URL") if uri.blank?
    return record.errors.add(attribute, "must be an HTTP or HTTPS URL") unless allowed_uri_scheme?(uri)

    record.errors.add(attribute, "must have a valid host") if uri.host.blank?
  end

  private

  def parse_uri(value)
    URI.parse(value)
  rescue URI::InvalidURIError
    nil
  end

  def allowed_uri_scheme?(uri)
    uri.is_a?(URI::HTTP) || uri.is_a?(URI::HTTPS)
  end
end
