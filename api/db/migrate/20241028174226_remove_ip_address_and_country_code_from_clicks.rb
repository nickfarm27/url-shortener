class RemoveIpAddressAndCountryCodeFromClicks < ActiveRecord::Migration[7.1]
  def change
    remove_column :clicks, :ip_address, :string
    remove_column :clicks, :country_code, :string
  end
end
