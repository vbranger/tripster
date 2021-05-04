class Trip < ApplicationRecord
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
