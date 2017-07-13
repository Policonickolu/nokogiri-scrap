require 'rubygems'
require 'nokogiri'
require 'open-uri'

PAGE_URL = "https://coinmarketcap.com/all/views/all/"

while true

  results = []

  page = Nokogiri::HTML(open(PAGE_URL)) 
  
  page.css('#currencies-all tbody tr').each do |row|
    
    results << {
      :name => row.css('td.currency-name img')[0]["alt"],
      :rate => row.css('td:nth-child(8)')[0]["data-usd"] || "???"
    }

  end

  results.sort! { |a, b| a[:name].downcase <=> b[:name].downcase }

  results.each do |x|
    puts "Le cours du #{x[:name]} est de #{x[:rate]} %."
  end

  sleep 3600
end
