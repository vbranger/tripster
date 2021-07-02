class Trip < ApplicationRecord
  # declaration des steps sur formulaire de création d'un trip
  cattr_accessor :form_steps do
    %w[destination dates]
  end
  # pour pouvoir savoir à quelle step on est
  attr_accessor :form_step
  
  include AASM

  aasm do
    state :not_started, initial: true
    state :propositions
    state :votes
    state :draw
    state :choosen
    state :booked

    event :start_propositions do
      transitions from: [:not_started], to: :propositions
    end

    event :start_votes do
      transitions from: [:propositions], to: :votes
    end

    event :choose_room do
      transitions from: [:votes, :draw], to: :choosen
    end

    event :set_as_draw do
      transitions from: [:votes], to: :draw
    end

    event :set_as_booked do
      transitions from: [:choosen], to: :booked
    end

    event :back_propositions do
      transitions from: [:votes], to: :propositions
    end

    event :back_votes do
      transitions from: [:choosen, :draw], to: :votes
    end

    event :unbook do
      transitions from: [:booked], to: :choosen
    end
  end

  has_many :participants, dependent: :destroy
  has_many :users, through: :participants
  has_many :rooms, dependent: :destroy
  has_many :invites
  has_many :news, as: :imageable
  belongs_to :user
  validates :name, presence: true
  validate :dates_correct?

  # VALIDATION MULTIPLE FORM STEPS
  def required_for_step?(step)
    # All fields are required if no form step is present
    return true if form_step.nil?
  
    # All fields from previous steps are required if the
    # step parameter appears before or we are on the current step
    return true if form_steps.index(step.to_s) <= form_steps.index(form_step)
  end

  def participants_list
    string = ""
    participants = self.participants
    participants.each do |participant|
      if participant == participants.last
        string += participant.user.first_name
      else
        string += "#{participant.user.first_name}, "
      end
    end
    return string
  end

  def photo_url?
    return true unless photo_url.nil? || photo_url == ""
  end

  # les deux prochaines méthodes devront disparaitre lorsque nous auront codé les autres process
  def destination_chosen?
    self.destination && !self.destination.empty? ? true : false
  end

  def dates_chosen?
    self.start_date != nil && self.end_date != nil
  end

  def dates_correct?
    return if end_date.nil? || start_date.nil?

    errors.add(:end_date, "can't be inferior to starting date") if end_date < start_date
  end
end
