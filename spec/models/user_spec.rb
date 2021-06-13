require 'rails_helper'

RSpec.describe User, type: :model do
  subject {
    build(:user)
  }

  it "is valid with valid attributes" do
    expect(subject).to be_valid
  end

  it { should have_many(:participants).dependent(:destroy) }
  it { should have_many(:trips).through(:participants) }
  it { should have_many(:reviews).dependent(:destroy) }
  it { should have_many(:invitations) }
  it { should have_many(:sent_invites) }
  it { should validate_presence_of(:first_name) }
  it { should validate_presence_of(:last_name) }

  describe "#avatar_color" do
    it "returns one of the color of AVATAR_COLORS" do
      expect(described_class::AVATAR_COLORS).to include(subject.avatar_color)
    end
  end
end
