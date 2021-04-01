class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable
  has_many :participants, dependent: :destroy
  has_many :trips, through: :participants
  has_many :invitations, :class_name => "Invite", :foreign_key => 'recipient_id'
  has_many :sent_invites, :class_name => "Invite", :foreign_key => 'sender_id'
  validates :first_name, presence: true
  validates :last_name, presence: true
  acts_as_voter

  # Override Devise::Confirmable#after_confirmation
  def after_confirmation
    UserMailer.welcome(self).deliver_now
  end
  
end
