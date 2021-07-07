class Review < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_many :news, as: :imageable, dependent: :destroy
  validates :score, presence: true, inclusion: { in: [0, 1, 2, 3, 4, 5] }

  after_create :update_avg_score
  after_update :update_avg_score
  after_destroy :update_avg_score


  def update_avg_score
    reviews = Review.where(room: room)
    scores = reviews.map(&:score)
    unless scores.empty?
      avg = scores.inject { |sum, x| sum + x } / scores.length.to_f
    end
    room.update(avg_score: avg)
  end

end
