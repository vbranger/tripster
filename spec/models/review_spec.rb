require 'rails_helper'

RSpec.describe Review, type: :model do
  subject {
    described_class.new(
      room: create(:room),
      user: create(:user),
      score: 5
    )
  }

  it { should have_many(:news).dependent(:destroy) }
  it { should validate_presence_of(:score) }
  it do
    should validate_inclusion_of(:score)
      .in_array(%w[0 1 2 3 4 5])
  end
  it { should belong_to(:room) }
  it { should belong_to(:user) }
  it "triggers #update_avg_score on save" do
    expect(subject).to receive(:update_avg_score)
    subject.save
  end

  it "should trigger #update_avg_score on update" do
    review = create(:review)
    expect(review).to receive(:update_avg_score)
    review.update(score: 3)
  end

  it "should trigger #update_avg_score on delete" do
    expect(subject).to receive(:update_avg_score)
    subject.destroy
  end


  describe "#update_avg_score" do
    it "updates its room avg_score when a new Review is created" do
      initial_score = subject.room.avg_score
      create(:review, score: 5, room: subject.room)
      subject.room.avg_score
      expect(subject.room.avg_score).not_to eq(initial_score.to_i)
    end

    it "returns the average score of room reviews" do
      room = create(:room)
      
      create(:review, score: 2, room: room, user: create(:user))
      create(:review, score: 3, room: room, user: create(:user))
      create(:review, score: 2, room: room, user: create(:user))
      create(:review, score: 4, room: room, user: create(:user))
      create(:review, score: 1, room: room, user: create(:user))

      expect(room.avg_score).to eq(2.4)
    end
  end
end