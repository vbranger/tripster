class Notification < ApplicationRecord
  belongs_to :user
  belongs_to :imageable, polymorphic: true

  def time_since
    
  end
end
