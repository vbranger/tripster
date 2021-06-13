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
  # VALIDATIONS & ASSOCIATIONS
  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end
  it { should have_many(:participants).dependent(:destroy) }
  it { should have_many(:users).through(:participants) }
  it { should have_many(:rooms).dependent(:destroy) }
  it { should have_many(:invites) }
  it { should have_many(:news) }
  it { should belong_to(:user) }
  it { should validate_presence_of(:name) }
  it "is not valid if end date is before start" do
    subject.end_date = Date.today - 1
    expect { subject.save! }.to raise_error(ActiveRecord::RecordInvalid)
  end
  # METHODES D'INSTANCE
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
  # AASM
  describe "aasm steps" do
    describe ":not_started" do
      it "should be an initial state" do
        expect(subject).to be_not_started
      end
      it "should change to :propositions on :start_propositions" do
        subject.start_propositions
        expect(subject).to be_propositions
      end
    end
  end
end
