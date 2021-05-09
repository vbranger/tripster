class Trip < ApplicationRecord
  include AASM

  aasm column: 'room_state' do
    state :not_started, initial: true
    state :propositions
    state :votes
    state :finished

    event :start_propositions do
      transitions from: [:not_started], to: :propositions
    end

    event :start_votes do
      transitions from: [:propositions], to: :votes
    end

    event :choose_room do
      transitions from: [:votes], to: :finished
    end

    event :back_propositions do
      transitions from: [:votes], to: :propositions
    end

    event :back_votes do
      transitions from: [:finished], to: :votes
    end
  end


  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :rooms, dependent: :destroy
  has_many :invites
  has_many :notifications, as: :imageable
  belongs_to :user

  def participants_list
    string = ""
    participants = self.participants
    participants.each do |participant|
      if participant == participants.last
        string += participant.user.first_name
      else
        string += participant.user.first_name + ', '
      end
    end
    return string
  end

  def destination_chosen?
    self.destination && !self.destination.empty? ? true : false
  end

  def dates_chosen?
    self.start_date != nil && self.end_date != nil
  end

end
