require 'open-uri'
require 'nokogiri'
require 'ferrum'
# require 'webdrivers/chromedriver'

class Room < ApplicationRecord
  belongs_to :trip
  acts_as_votable

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
    # url = "https://www.airbnb.fr/embeddable/home?id=#{self.web_id}"
    if self.start_date != self.end_date
      url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.participants.size}&check_in=#{self.start_date}&check_out=#{self.end_date}"
    else
      t = Time.now
      today = "#{t.year}-#{t.month}-#{t.day}"
      tomorrow = "#{t.year}-#{t.month}-#{t.day.to_i + 1}"
      url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.participants.size}&check_in=#{self.start_date}&check_out=#{self.end_date}"
    end
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

    # CODE POUR LA PROD
    browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    browser.go_to(url)
    sleep(10)
    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    p title = html_doc.search('._mbmcsn h1').children.text
    p photo = html_doc.search('._6tbg2q')
    p price = html_doc.search('._pgfqnw')
    self.name = title
    # FIN CODE POUR LA PROD


    # CODE POUR LOCAL VB
    # br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    # br.go_to(url)
    # html_doc = Nokogiri::HTML(br.body)
    # p house_name = html_doc.search("#listing-#{self.web_id} > div._hgs47m > div > div > a > div._wlyu2v > span > span").children.text
    # self.name = house_name
    # p photo = html_doc.search("#listing-#{self.web_id} > div._1dp4576 > div._e296pg > div._gjw2an > div > div > div")
    # unless photo.empty? # pour gérer les maisons non identifiées sur airbnb
    #   p get_img_url(photo.last.attributes["style"].value)
    # end
    # br.quit
    # FIN CODE VALIDE

  end

end
