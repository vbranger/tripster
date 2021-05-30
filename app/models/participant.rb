class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :notifications, as: :imageable
  validates :user_id, uniqueness: { scope: :trip_id, message: "already on the trip" }

  def active?(params, user, current_user)
    if params[:user_id].nil?
      if user == current_user
        true
      else
        false
      end
    elsif params[:user_id] && user.id == params[:user_id].first.to_i
      true
    else
      false
    end
  end
end
