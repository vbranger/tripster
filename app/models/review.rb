class Review < ApplicationRecord
  belongs_to :room

  validates :score, presence: true, :inclusion => {:in => [0,1,2,3,4,5]}
end
