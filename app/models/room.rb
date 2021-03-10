require 'open-uri'
require 'nokogiri'

class Room < ApplicationRecord
  belongs_to :trip

  def get_id
    match_data = self.url.match(/^(?<website_url>https:\/\/www.airbnb.[a-z]+\/rooms\/)(?<id>\d+)/)
    return self.web_id = match_data[:id]
  end

  def scrap
    url = "https://www.airbnb.fr/rooms/#{self.web_id}"
    # url = "https://medium.com/@LindaVivah/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c"
    p url
    html_file = open(url).read
    p html_file
    html_doc = Nokogiri::HTML(html_file)
    title = html_doc.search('#site-content > div > div > div:nth-child(1) > div:nth-child(1) > div > div > div > div > section > div > div._mbmcsn > h1')
    p "TEST TEST TEST TEST"
    p title
    self.name = title.text.strip
  end

end
