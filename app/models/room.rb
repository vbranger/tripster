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
    # p url
    # html_file = open(url)
    # p html_file
    # p "sleeping sleeping TEST TEST"
    # p html_file
    # p html_file = html_file.read
    # html_doc = Nokogiri::HTML(html_file)
    # title = html_doc.search('#site-content > div > div > div:nth-child(1) > div:nth-child(1) > div > div > div > div > section > div > div._mbmcsn > h1')
    # p "TEST TEST TEST TEST"
    # p title
    # self.name = title.text.strip
    # browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    # browser.go_to(url)
    # sleep(5)
    # p browser.at_css('h1')
    # # html_doc = Nokogiri::HTML(browser.body)
    # browser.quit
    # # p html_doc

    br = Ferrum::Browser.new(timeout: 60)
    br.go_to('https://www.airbnb.fr/rooms/34108527?source_impression_id=p3_1615470800_6I91lDfpEIXf2e%2Fq&guests=1&adults=1')
    # loop do
    #   break if br.evaluate("document.readyState") == "complete"
    # end
    sleep(10)
    p br.at_css("h1")

    # html_doc = Nokogiri::HTML(br.body)
    # p br.body
    # br.quit
    # p html_doc.search('h1')
  end

end
