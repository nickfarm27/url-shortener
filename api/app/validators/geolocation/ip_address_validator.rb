class Geolocation::IpAddressValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    begin
      IPAddr.new(value)
    rescue
      record.errors.add(attribute, "#{value} is not a valid IP address")
    end
  end
end
