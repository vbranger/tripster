class Trip < ApplicationRecord
  has_many :participants, dependent: :destroy
  has_many :rooms, dependent: :destroy
  belongs_to :user

  def participants_list
    string = ""
    participants = self.participants
    p participants
    participants.each do |participant|
      if participant == participants.last
        string += participant.user.email
      else
        string += participant.user.email + ', '
      end
    end
    return string
  end

  def destination_choosen?
    self.destination && !self.destination.empty? ? true : false
  end

  def dates_choosen?
    self.start_date != nil && self.end_date != nil
  end

end
