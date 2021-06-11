require 'rails_helper'

describe Trip do
  describe "#participants_list" do
    it "returns a string" do
      trip = Trip.new(name: "test")

      expect(trip.participants_list).to be_a(String)
    end
    it "returns the list of all participants" do
      users = []
      # users << User.create!(first_name: "Victor", last_name: "Branger", email: "victor@gmail.com", password: "123456")
      users << create(:user, first_name: "Victor")
      users << create(:user, first_name: "Camille")
      users << create(:user, first_name: "Louis")
      trip = create(:trip)
      users.each { |user| Participant.create!(user: user, trip: trip) }
      expect(trip.participants_list).to eq('Victor, Camille, Louis')
    end
  end
end