class Review < ApplicationRecord
  belongs_to :room
  belongs_to :user
  has_many :news, as: :imageable, dependent: :destroy
  validates :score, presence: true, :inclusion => {:in => [0,1,2,3,4,5]}

  after_create :update_avg_score
  
  def update_avg_score
    scores = self.room.reviews.map {|review| review.score}
    avg = scores.inject(0){|sum,x| sum + x } / scores.length.to_f
    self.room.update(avg_score: avg)
  end

end
