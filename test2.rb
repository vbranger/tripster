require 'ferrum'
require 'nokogiri'
require 'open-uri'

url = "https://www.airbnb.fr/rooms/34108527"
br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
br.go_to(url)
html_doc = Nokogiri::HTML(br.body)
p house_name = html_doc.search("#listing-34108527 > div._hgs47m > div > div > a > div._wlyu2v > span > span").children.text
p photo = html_doc.search("#listing-34108527 > div._1dp4576 > div._e296pg > div._gjw2an > div > div > div")
br.quit