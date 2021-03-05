class Trip < ApplicationRecord
  has_many :participants, dependent:destroy
end
