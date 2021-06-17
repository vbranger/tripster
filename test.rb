require 'selenium-webdriver'
require 'watir'
require 'socksify/http'
require 'headless'


proxy = Selenium::WebDriver::Proxy.new( socks: '127.0.0.1:9050',socks_version: 5)
caps = Selenium::WebDriver::Remote::Capabilities.chrome(proxy: proxy)
# Configure Watir to use tor proxy
browser = Watir::Browser.new(:chrome ,desired_capabilities: caps, headless: true)
#now we can make request which uses tor
browser.goto 'https://www.airbnb.com'
#it will show Tor Ip address on chrome browser
browser.screenshot.save "test-watir.png"
