require 'open-uri'
require 'nokogiri'
require 'ferrum'

class Room < ApplicationRecord
  belongs_to :trip

  def get_id
    match_data = self.url.match(/^(?<website_url>https:\/\/www.airbnb.[a-z]+\/rooms\/)(?<id>\d+)/)
    return self.web_id = match_data[:id]
  end

  def get_img_url(value)
    match_data = value.match(/(https:.+")/)
    p self.photo = match_data[0][0..-2]
    return self.photo
  end

  def scrap
    url = "https://www.airbnb.fr/embeddable/home?id=#{self.web_id}"
    # url = "https://medium.com/@LindaVivah/the-beginner-s-guide-scraping-in-ruby-cheat-sheet-c4f9c26d1b8c"
    # p url
    # p url
    # html_file = open(url).read
    # p html_file
    # p "sleeping sleeping TEST TEST"
    # p html_file
    # p html_file = html_file.read
    # html_doc = Nokogiri::HTML(html_file)
  
    # p title
    # self.name = title.text.strip

    # browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    # browser.go_to(url)
    # html_doc = Nokogiri::HTML(browser.body)
    # info = html_doc.search('#listing-13967239 > div._hgs47m > div')
    # p info
    # title = html_doc.search('#listing-13967239 > div._hgs47m > div > div > a > div._wlyu2v > span > span')
    # p title
    # browser.quit

    # # p html_doc

    br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    br.go_to(url)
    html_doc = Nokogiri::HTML(br.body)
    p house_name = html_doc.search("#listing-#{self.web_id} > div._hgs47m > div > div > a > div._wlyu2v > span > span").children.text
    self.name = house_name
    p photo = html_doc.search("#listing-#{self.web_id} > div._1dp4576 > div._e296pg > div._gjw2an > div > div > div")
    unless photo.empty?
      p get_img_url(photo.last.attributes["style"].value)
    end
    br.quit
  end

end
