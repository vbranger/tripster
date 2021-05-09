class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new
    @trip = params[:trip]
  end

  # probablement obsolète
  def create
    user = User.where(email: params[:email])
    unless user.empty?
      @participant = Participant.new(user_id: user.first.id, trip_id: params[:trip])
      @trip = Trip.find(params[:trip])
      if @participant.save
        UserMailer.notify_invitation(@participant.user, @trip).deliver_now
        redirect_to trip_path(@participant.trip)
      end
    else
      @participant = Participant.new
      @trip = params[:trip]
      render 'new'
    end
  end
  # fin probablement obsolète

  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    News.create!(user: @participant.user, trip_id: @participant.trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Participant", imageable_id: @participant)
    redirect_to trip_path(@participant.trip)
  end

  def save_room_votes
    @trip = Trip.find(params[:trip_id])
    @participant = Participant.find(params[:participant_id])
    room_votes = params[:room_votes].split(",")
    @participant.update(room_votes: room_votes)

    @participants = @trip.participants
    @participants_list = @trip.participants_list
    # test si tout le monde à voter
    if all_voted?(@participants)
      p "check votes"

      # array avec ID des meilleures
      p "Calculate choosen Rooms"
      p ids = calculate_choosen_room(@participants)
      @trip.update(choosen_room_ids: ids)
      @trip.choose_room!
    end

    redirect_to trip_rooms_path(@trip)
  end

  private

  def participant_params
    params.require(:participant).permit(:user_id, :trip_id, :room_votes)
  end

  def all_voted?(participants)
    participants.each do |participant|
      if participant.room_votes.empty?
        p "not voted"
        return false
      end
    end
    p "all voted"
    return true
  end

  def calculate_choosen_room(participants)
    participants_votes = participants.map {|participant| participant.room_votes}
    hash = calculation_inner(participants_votes)
    best_score = get_best_score(hash)
    find_rooms_with_best_score(hash, best_score)
  end

  def calculation_inner(participants_votes)
    rooms = {}

    participants_votes.each do |votes|
      votes.each_with_index do |id, index|
        rooms.has_key?(id) ? rooms[id] += index : rooms[id] = index
      end
    end
    rooms
  end

  def get_best_score(hash)
    hash.values.min_by{ |x| x }
  end

  def find_rooms_with_best_score(hash, best_score)
    rooms_ids = []
    hash.select { |_k, v| v == best_score}.keys.each { |k| rooms_ids << k }
  end

end
