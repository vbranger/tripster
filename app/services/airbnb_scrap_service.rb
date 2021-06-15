class AirbnbScrapService
    def initialize(url)
        @url = url
    end

    def call
        br = Ferrum::Browser.new({ timeout: 60, headless: true, process_timeout: 60 })
        br.go_to(@url)
        attributes.values.each {|attribute| wait_for(attribute[:css], br)}
        
        html_doc = Nokogiri::HTML(br.body)
        result = {} 
        attributes.each do |k,attribute|
            result[k] = attributes[k][:method].call(html_doc.search(attribute[:css]))
        end
        br.quit
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

    def wait_for(css, br)
        node = nil
        while node.nil?
            node = br.at_css(css)
            sleep 0.1
        end
        node
    end

    def get_img_url(value)
        match_data = value.match(/(https:.+")/)
        match_data[0][0..-2]
    end
end