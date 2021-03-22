class User < ApplicationRecord
  after_create :send_welcome_email
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :participants, dependent: :destroy
  has_many :trips, through: :participants
  acts_as_voter

  private

  def send_welcome_email
    UserMailer.welcome(self).deliver_now
  end
  
end
