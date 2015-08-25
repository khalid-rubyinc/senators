#!/usr/bin/env ruby
require 'nokogiri'
require 'street_address'
require 'pry'
require 'csv'
require 'open-uri'

Pry.pager = nil

doc = Nokogiri::HTML(open("http://www.senate.gov/general/contact_information/senators_cfm.xml")); nil

CSV.open('senators.csv', 'w') do |csv|
  csv << %w(First_name Last_name Organization Address1 Address2 Address3 City State Zip Country_non-US)

  doc.xpath('//member').each do |member|
    first_name = member.css('first_name').inner_html
    last_name = member.css('last_name').inner_html
    address =  member.css('address').inner_html
    address.gsub!(/ Washington/, ', Washington,')
    address.gsub!(/DC/, 'DC,')
    street_address = StreetAddress::US.parse address

    csv << [first_name, last_name, 'Senator', street_address.line1, nil, nil, street_address.city, street_address.state, street_address.postal_code, nil ]
  end
end
