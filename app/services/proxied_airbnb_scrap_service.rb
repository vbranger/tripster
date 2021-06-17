require 'socksify/http'

class ProxiedAirbnbScrapService
  def initialize(url)
    @url = url
  end

  def call
    require 'socket'

    p addr_infos = Socket.ip_address_list

    http = Net::HTTP::SOCKSProxy('127.0.0.1', 9050)
    url = 'https://ident.me'
    puts http.get(URI(url))

    p exception_keys = [] << :price if (!@url.include?("check_in") || !@url.include?("check_out"))

    browser = Ferrum::Browser.new({
      timeout: 60, headless: true,
      process_timeout: 60,
      :browser_options=> {"proxy-server"=> "#{http.get(URI(url))}"}
    })

    browser.go_to(@url)
    sleep 7
    browser.screenshot(path:"first-screenshot.jpeg")


    # attributes.except(*exception_keys).each_value {|attribute| wait_for(attribute[:css], browser)}


    html_doc = Nokogiri::HTML(browser.body)
    result = {}
    attributes.except(*exception_keys).each do |k,attribute|
      result[k] = attributes[k][:method].call(html_doc.search(attribute[:css]))
    end
    browser.quit
    result
  end

  def attributes
    {
      name: {
        css:"._9cqu50 > h1",
        method: lambda {|var| var.text}
      },
      photo: {
        css:"._6tbg2q",
        method: lambda {|var| var.first.attributes["data-original-uri"].value}
      },
      price: {
        css:"._hdznyn > ._1k4xcdh",
        method: lambda {|var| var.children.text.gsub(/\D/, "").to_i}
      }
    }
  end


  private

  def wait_for(css, browser)
    node = nil
    while node.nil?
      p "waiting for #{css}"
      node = browser.at_css(css)
      sleep 1
    end
    p "founded"
    node
  end

  def get_img_url(value)
    match_data = value.match(/(https:.+")/)
    match_data[0][0..-2]
  end
end
