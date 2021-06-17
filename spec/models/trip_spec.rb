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
      users << create(:user, first_name: "Camille")
      users << create(:user, first_name: "Louis")
      trip = create(:trip, user: create(:user, first_name: "Victor"))
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
      it "should change to :votes from :propositions on :start_votes" do
        subject.aasm_state = "propositions"
        subject.start_votes
        expect(subject).to be_votes
      end
      it "should change to :choosen from :votes on :choose_room" do
        subject.aasm_state = "votes"
        subject.choose_room
        expect(subject).to be_choosen
      end

      it "should change to :draw from :votes on :choose_room" do
        subject.aasm_state = "draw"
        subject.choose_room
        expect(subject).to be_choosen
      end

      it "should change to :draw from :votes on :set_as_draw" do
        subject.aasm_state = "votes"
        subject.set_as_draw
        expect(subject).to be_draw
      end

      it "should change to :booked from :choosen on :set_as_booked" do
        subject.aasm_state = "choosen"
        subject.set_as_booked
        expect(subject).to be_booked
      end

      it "should change to :propositions from :votes on :back_propositions" do
        subject.aasm_state = "votes"
        subject.back_propositions
        expect(subject).to be_propositions
      end

      it "should change to :votes from :choosen on :back_votes" do
        subject.aasm_state = "choosen"
        subject.back_votes
        expect(subject).to be_votes
      end

      it "should change to :votes from :draw on :back_votes" do
        subject.aasm_state = "draw"
        subject.back_votes
        expect(subject).to be_votes
      end

      it "should change to :choosen from :booked on :unbook" do
        subject.aasm_state = "booked"
        subject.unbook
        expect(subject).to be_choosen
      end
    end
  end
end
