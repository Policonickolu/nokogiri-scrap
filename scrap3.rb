require 'rubygems'
require 'nokogiri'
require 'open-uri'

PAGE_URL = "https://en.wikipedia.org"


def crawl_page_and_select_first_link href, results

  page = Nokogiri::HTML(open(PAGE_URL + href))

  title = page.css('#firstHeading')[0].text
  first_link = ""

  results[:count] = (results[:count] || 0) + 1
  results[:pages] = (results[:pages] || []) << title
  results[:hrefs] = (results[:hrefs] || []) << href

  html = page.css('#mw-content-text > div > p,
          #mw-content-text > div > ul,
          #mw-content-text > div > blockquote')

  html.css('a:not(.new)').each do |a|


    if a["href"] != href && a["href"].respond_to?(:scan)

      if a["href"].scan(/^\/wiki\/(?!Wikipedia:|File:|Portal:|Category:|Special:|Help:).*$/).length > 0
        
        first_link = a["href"]
        break

      end

    end

  end
  
  unless href == "/wiki/Philosophy" || first_link == "" || results[:hrefs].include?(first_link)

    results = crawl_page_and_select_first_link(first_link, results) 

  else
    results[:last] = title
  end

  return results

end


results = crawl_page_and_select_first_link("/wiki/Special:Random", Hash.new)



puts "Pages visitées : #{results[:count]}"
puts "De \"#{results[:pages][0]}\" à \"#{results[:pages][-1]}\""
puts "Liste des pages :"
results[:pages].each { |x| puts x }