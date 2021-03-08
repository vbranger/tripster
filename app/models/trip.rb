class Trip < ApplicationRecord
  has_many :participants, dependent: :destroy
  belongs_to :user
end
