require 'rails_helper'

RSpec.describe Trip, type: :model do

  subject {
    described_class.new(
      name: 'test',
      user: create(:user),
      start_date: Date.today,
      end_date: Date.today + 1
    )
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it "is not valid without a name" do
    subject.name = nil
    expect(subject).not_to be_valid
  end

  it "is not valid without a user" do
    subject.user = nil
    expect(subject).not_to be_valid
  end

  it "is not valid if end date is before start" do
    subject.end_date = Date.today - 1

    expect{subject.save!}.to raise_error(ActiveRecord::RecordInvalid)
  end

  describe "#participants_list" do

    it "returns a string" do
      trip = Trip.new(name: "test")

      expect(trip.participants_list).to be_a(String)
    end

    it "returns the list of all participants" do
      users = []
      users << create(:user, first_name: "Victor")
      users << create(:user, first_name: "Camille")
      users << create(:user, first_name: "Louis")
      trip = create(:trip)
      users.each { |user| Participant.create!(user: user, trip: trip) }
      expect(trip.participants_list).to eq('Victor, Camille, Louis')
    end

  end

end