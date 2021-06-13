class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :participants, dependent: :destroy
  has_many :trips, through: :participants
  has_many :reviews, dependent: :destroy
  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'
  validates :first_name, presence: true
  validates :last_name, presence: true
  acts_as_voter

  AVATAR_COLORS = ['#00AA55', '#009FD4', '#B381B3', '#939393', '#E3BC00', '#D47500', '#DC2A2A']

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    UserMailer.welcome(self).deliver_now
  end

  def participant(trip)
    Participant.where(user_id: self.id, trip_id: trip.id).first
  end

  def avatar_color
    # convertion initial en chiffre
    initials = []
    initials << self.first_name.first.ord
    initials << self.last_name.first.ord
    # initials = [44,55] par ex
    number = initials.join.to_i
    AVATAR_COLORS[number % AVATAR_COLORS.count]
  end
end
