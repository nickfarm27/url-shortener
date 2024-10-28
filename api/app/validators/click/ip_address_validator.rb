class Click::IpAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?

    begin
      IPAddr.new(value)
    rescue IPAddr::InvalidAddressError
      record.errors.add(attribute, "#{value} is not a valid IP address")
    end
  end
end
