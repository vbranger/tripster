require "selenium-webdriver"

# configure the driver to run in headless mode
options = Selenium::WebDriver::Chrome::Options.new
options.add_argument('--headless')
options.add_argument('--no-sandbox')
options.add_argument('--disable-gpu')
options.add_argument('--window-size=1280,1024')
options.add_argument('--disable-features=VizDisplayCompositor')
options.add_argument('--enable-features=NetworkService,NetworkServiceInProcess')
driver = Selenium::WebDriver.for :chrome, options: options

# navigate to a really super awesome blog
driver.navigate.to "https://www.airbnb.fr/rooms/34108527?source_impression_id=p3_1620981071_2N%2BrrPE9J7cJBICp&guests=1&adults=1"
p driver
wait = Selenium::WebDriver::Wait.new(:timeout => 60)
# p driver
test = wait.until {
  driver.find_element(:css, 'h1')
}
p test.text

test2 = wait.until {
  driver.find_element(:css, '#root > div.listing-page.listing-page--desktop > main > div.pdp-layout > div.pdp-layout__right-col > div > div > div:nth-child(2) > div > div.right-rail__top-container > div.right-rail__row > div.right-rail__rate > div > span')
}
p test2.text


driver.quit
# price = wait.until {
  # element2 = driver.find_element(:css, "#root > div.listing-page.listing-page--desktop > main > div.pdp-layout > div.pdp-layout__right-col > div > div > div:nth-child(2) > div > div.right-rail__top-container > div.right-rail__row > div.right-rail__rate > div > span")
# }
# puts price.text