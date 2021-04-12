class Participant < ApplicationRecord
  belongs_to :user
  belongs_to :trip
  has_many :notifications, as: :imageable
end
