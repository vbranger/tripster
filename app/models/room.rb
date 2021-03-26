require 'open-uri'
require 'nokogiri'
require 'ferrum'
# require 'webdrivers/chromedriver'

class Room < ApplicationRecord
  belongs_to :trip
  acts_as_votable

  MONTHS = {
    'janvier'  => 1, 'février' => 2, 'mars'    => 3, 'avril'    => 4,
    'mai'      => 5, 'juin'     => 6, 'juillet'     => 7, 'août'   => 8,
    'septembre'=> 9, 'octobre'  => 10, 'novembre' => 11, 'décembre' => 12
  }

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
    # if self.trip.start_date != self.trip.end_date
    #   url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.trip.participants.size}&check_in=#{self.trip.start_date}&check_out=#{self.trip.end_date}"
    # else
    #   t = Time.now
    #   today = "#{t.year}-#{t.month}-#{t.day}"
    #   tomorrow = "#{t.year}-#{t.month}-#{t.day.to_i + 1}"
    #   url = "https://www.airbnb.fr/rooms/#{self.web_id}?adults=#{self.trip.participants.size}&check_in=#{today}&check_out=#{tomorrow}"
    # end
    p url = "https://www.airbnb.fr/rooms/#{self.web_id}"

    browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    browser.go_to(url)
    sleep(10)
    p "Search for tables"
    p tables = browser.css('table')
    while tables.empty?
      p "not found yet, retry in 1sec"
      tables = browser.css('table')
      sleep(0.1)
    end
    p "Print Tds"
    p tds = tables.last.css('td')
    p "start iteration in tds"
    dates = []
    tds.each do |td|
      p td
      break if dates.count == 2
      if !td.description['attributes'].empty? && td.description['attributes'][7].include?("Choisissez")
        p "date disponible"
        match_data = td.description['attributes'][7].match(/(Choisissez \w+, )(\d+ \w+ \d{4})/)
        p "Conversion date from 6 avril 2021 to 2021-04-06"
        p date = match_data[2]
        dates << date_conversion(date)
        p "séjour minimum"
        second_match_data = td.description['attributes'][7].match(/(minimum de )(\d+)/)
        p second_match_data[2]
      end
    end
    p dates
    p "getting title"
    p title = browser.at_css('._mbmcsn h1').text
    p "getting photo"
    p photo = browser.at_css('._6tbg2q').description['attributes'][11]
    p "browser quit"
    browser.quit

    p "new url"
    p url = "https://www.airbnb.fr/rooms/#{self.web_id}?check_in=#{dates[0]}&check_out=#{dates[1]}"
    
    p "new browser"
    browser = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
    browser.go_to(url)
    sleep(10)
    p price = browser.at_css('._pgfqnw').text.gsub!('€','')

    # url = "https://www.airbnb.fr/rooms/45359210?check_in=2021-04-05&check_out=2021-04-07"

    # NOKO IN
    # html_doc = Nokogiri::HTML(browser.body)
    # p title = html_doc.search('._mbmcsn h1').children.text
    # p photo = html_doc.search('._6tbg2q').attr('src').value


    # p price = html_doc.search('._pgfqnw').children.text
    # self.name = title
    # self.photo = photo
    # length = price.length/2
    # self.price = price[0...-length].gsub!("€","").to_f
    # NOKO OUT 

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

  private

  def date_conversion(string_date)
    match_data = string_date.match(/(?<day>\d{1,2})(\s)(?<month>\w+)(\s)(?<year>\d{4})/)
    month = MONTHS[match_data[:month]]
    return "#{match_data[:year]}-#{month}-#{match_data[:day]}"
  end

end
