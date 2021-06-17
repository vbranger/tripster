require "rails_helper"

RSpec.describe AirbnbScrapService, type: :service do
  describe "#scrap" do
    context "url with available dates" do 
      url = "https://www.airbnb.fr/rooms/34108527?source_impression_id=p3_1623750023_3%2F%2BcJ1dr9LGKw1Ph&check_in=2021-09-25&guests=1&adults=1&check_out=2021-10-02"
      xit "should return the good name, photo and price" do
        scrap = AirbnbScrapService.new(url)
        scrap_result = scrap.call
        
        expect(scrap_result).to include({price:2558})
      end
    end 
    context "url without dates" do 
      url = "https://www.airbnb.fr/rooms/34108527"
      xit "should return the good name and photo" do
        scrap = AirbnbScrapService.new(url)
        scrap_result = scrap.call
        result = {
            name: "A 150 m de la plage, villa avec piscine chauffée",
            photo: "https://a0.muscache.com/pictures/0f292521-513d-4e4e-a933-01fa0b29a683.jpg",
        }

        expect(scrap_result).to eq(result)
      end 
    end
  end
end