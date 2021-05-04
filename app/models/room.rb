require 'open-uri'
require 'nokogiri'
require 'ferrum'
# require 'webdrivers/chromedriver'

class Room < ApplicationRecord
  belongs_to :trip
  has_many :notifications, as: :imageable
  has_many :reviews, dependent: :destroy
  acts_as_votable

  MONTHS = {
    'janvier'  => 1, 'février' => 2, 'mars'    => 3, 'avril'    => 4,
    'mai'      => 5, 'juin'     => 6, 'juillet'     => 7, 'août'   => 8,
    'septembre'=> 9, 'octobre'  => 10, 'novembre' => 11, 'décembre' => 12
  }

  def get_airbnb_id
    match_data = self.url.match(/^(?<website_url>https:\/\/www.airbnb.[a-z]+\/rooms\/)(?<id>\d+)/)
    return self.web_id = match_data[:id]
  end

  def get_abritel_id
    match_data = self.url.match(/(?<website_url>www.abritel.fr\/location-vacances\/)(?<id>p\w+)/)
    return self.web_id = match_data[:id]
  end

  def convert_url
    br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    br.go_to(url)
    p br.current_url
    update(url: br.current_url)
    br.quit
  end

  def get_img_url(value)
    match_data = value.match(/(https:.+")/)
    p self.photo = match_data[0][0..-2]
    return self.photo
  end

  def scrap_airbnb
    
    # CODE POUR LOCAL VB
    url = "https://www.airbnb.fr/embeddable/home?id=#{self.web_id}"
    br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    br.go_to(url)
    html_doc = Nokogiri::HTML(br.body)
    p house_name = html_doc.search("#listing-#{self.web_id} > div._hgs47m > div > div > a > div._wlyu2v > span > span").children.text
    self.name = house_name
    p photo = html_doc.search("#listing-#{self.web_id} > div._1dp4576 > div._e296pg > div._gjw2an > div > div > div")
    unless photo.empty? # pour gérer les maisons non identifiées sur airbnb
      p get_img_url(photo.last.attributes["style"].value)
    end
    self.price = rand(80..300).to_f
    br.quit
    # FIN CODE VALIDE

  end

  def scrap_abritel
    # url = "https://www.abritel.fr/location-vacances/#{self.web_id}"
    br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    br.go_to(url)
    html_doc = Nokogiri::HTML(br.body)
    overview = html_doc.search("#overview")
    house_name = overview.search("h1").text
    self.name = house_name
    photos = html_doc.search("#photos")
    self.photo = photos.search("img").first.attributes["src"].value
    self.price = rand(80..300).to_f
    br.quit
  end
  

  private

  def date_conversion(string_date)
    match_data = string_date.match(/(?<day>\d{1,2})(?<space1>\s)(?<month>\w+)(?<space2>\s)(?<year>\d{4})/)
    month = MONTHS[match_data[:month]]
    return "#{match_data[:year]}-#{month}-#{match_data[:day]}"
  end

end
