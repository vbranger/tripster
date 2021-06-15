require 'rails_helper'

RSpec.describe Room, type: :model do
  subject {
    build(:room)
  }

  describe "#universal_scrap" do
    def self.test_name(url, result)
      it "should return the good name" do
        subject.url = url
        subject.universal_scrap

        expect(subject.name).to include(result)
      end
    end

    def self.test_photo(url)
      it "should set an URL for photo" do
        subject.url = url
        subject.universal_scrap

        expect(subject.photo).to include('https://')
      end
    end

    context "with booking url" do
      url = "https://www.booking.com/hotel/it/residence-150.fr.html"
      test_name(url, 'Ferrini')
      test_photo(url)
    end

    context "with abritel url" do
      url = "https://www.abritel.fr/location-vacances/p1590687"
      test_name(url, 'Château dans magnifique parc arboré')
      test_photo(url)
    end

    context "with airbnb url" do
      url = "https://www.airbnb.fr/rooms/34108527"
      test_name(url, 'A 150 m de la plage')
      test_photo(url)
    end
  end

  describe "#scrap_airbnb" do
    url = "https://www.airbnb.fr/rooms/34108527"
    it "should return the good name" do
      subject.url = url
      subject.get_airbnb_id
      subject.scrap_airbnb
      expect(subject.name).to include('A 150 m de la plage')
    end

    it "should set an URL for photo" do
      subject.url = url
      subject.get_airbnb_id
      subject.scrap_airbnb
      expect(subject.photo).to include('https://')
    end
  end

  describe "#scrap_abritel" do
    url = "https://www.abritel.fr/location-vacances/p1590687"
    it "should return the good name" do
      subject.url = url
      subject.get_abritel_id
      subject.scrap_abritel
      expect(subject.name).to include('A 150 m de la plage')
    end

    it "should set an URL for photo" do
      subject.url = url
      subject.scrap_abritel
      expect(subject.photo).to include('https://')
    end
  end
end
