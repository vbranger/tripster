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

end
