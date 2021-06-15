require "rails_helper"

RSpec.describe UniversalScrapService, type: :service do
    describe "#scrap" do
        def self.test_scrap(url, result, success)
            it "should return the #{success} informations" do
                scrap = UniversalScrapService.new(url)
                scrap_result = scrap.call
                expect(scrap_result).to eq(result)
            end
        end
        context "booking" do
            url = "https://www.booking.com/hotel/fr/best-western-international.fr.html"
            result = {
                name:"★★★ Best Western Hotel International, Annecy, France", 
                photo:"https://cf.bstatic.com/xdata/images/hotel/max1024x768/225816945.jpg?k=236aad57dd1a4751cf80985719eab9b9c232c9e37429a93f4a1a52cf18b1d7d2&o=&hp=1"
            }
            test_scrap(url,result, "good")
        end
        context "airbnb" do
            url = "https://www.airbnb.fr/rooms/34108527"
            result = {
                name:"", 
                photo:"https://a0.muscache.com/pictures/8a588149-01cf-4486-adb3-430324ccd68e.jpg"
            }
            test_scrap(url,result, "bad")
        end
        context "abritel" do
            url = "https://www.abritel.fr/location-vacances/p1590687"
            result = {
                name:"Château dans magnifique parc arboré avec piscine - Thuir", 
                photo:"https://media.vrbo.com/lodging/33000000/32650000/32640400/32640339/bad4f048.c10.jpg"
            }
            test_scrap(url,result, "good")
        end
    end 
end