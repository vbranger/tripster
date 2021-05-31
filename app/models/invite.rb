class Invite < ApplicationRecord
  belongs_to :trip
  belongs_to :sender, :class_name => 'User'
  belongs_to :recipient, :class_name => 'User', optional: true
  has_many :notifications, as: :imageable

  before_create :generate_token
  before_save :check_user_existence
  validates :email, uniqueness: { scope: :trip_id, message: "already received an invitation"}

  def check_user_existence
    recipient = User.find_by_email(email)
    if recipient
      self.recipient_id = recipient.id
    end
  end

  def generate_token
    self.token = Digest::SHA1.hexdigest([self.trip_id, Time.now, rand].join)
  end
end
