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
    # CODE POUR LA PROD
    if self.trip.start_date != self.trip.end_date
      url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.trip.participants.size}&check_in=#{self.trip.start_date}&check_out=#{self.trip.end_date}"
    else
      t = Time.now
      today = "#{t.year - 1}-#{t.month}-#{t.day}"
      tomorrow = "#{t.year - 1}-#{t.month}-#{t.day.to_i + 1}"
      url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.trip.participants.size}&check_in=#{today}&check_out=#{tomorrow}"
    end
    p url

    browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    browser.go_to(url)
    sleep(10)
    p "print on arrival_input"
    # price recovering
      # 1. fake arrival date
      p 'print arrival input'
      p arrival_input = browser.at_css('._11wiged')
      p "click on it"
      arrival_input.click
      p "search tables"
      p browser.at_css('table')

    html_doc = Nokogiri::HTML(browser.body)
    browser.quit
    p title = html_doc.search('._mbmcsn h1').children.text
    p photo = html_doc.search('._6tbg2q').attr('src').value


    p price = html_doc.search('._pgfqnw').children.text
    self.name = title
    self.photo = photo
    length = price.length/2
    self.price = price[0...-length].gsub!("€","").to_f
    # FIN CODE POUR LA PROD


    # CODE POUR LOCAL VB
    # url = "https://www.airbnb.fr/embeddable/home?id=#{self.web_id}"
    # br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    # br.go_to(url)
    # html_doc = Nokogiri::HTML(br.body)
    # p house_name = html_doc.search("#listing-#{self.web_id} > div._hgs47m > div > div > a > div._wlyu2v > span > span").children.text
    # self.name = house_name
    # p photo = html_doc.search("#listing-#{self.web_id} > div._1dp4576 > div._e296pg > div._gjw2an > div > div > div")
    # unless photo.empty? # pour gérer les maisons non identifiées sur airbnb
    #   p get_img_url(photo.last.attributes["style"].value)
    # end
    # self.price = rand(80..300).to_f
    # br.quit
    # FIN CODE VALIDE

  end

end
