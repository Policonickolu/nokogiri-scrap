require 'rubygems'
require 'nokogiri'
require 'open-uri'


def get_the_email_of_a_townhal_from_its_webpage url

  page = Nokogiri::HTML(open(url)) 

  return page.css('p.Style22 > font[size="2"]')[10].text[1..-1].strip

end

def get_all_the_urls_of_val_doise_townhalls

  domain = "http://annuaire-des-mairies.com"

  page = Nokogiri::HTML(open(domain + "/val-d-oise.html"))
  results = []

  page.css('table.Style20 tr a').each do |link|
    results << {
      :name => link.text.strip,
      :email => get_the_email_of_a_townhal_from_its_webpage(domain + link["href"][1..-1])
    }
  end

  return results

end

get_all_the_urls_of_val_doise_townhalls().each do |city|
  puts "#{city[:name]} : #{city[:email]}"
end