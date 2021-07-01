class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    if @trip.save
      redirect_to trip_form_step_path(@trip, Trip.form_steps.first)
      Participant.create!(trip_id: @trip.id, user_id: current_user.id)
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Trip", imageable_id: @trip.id)
    else
      render :new
    end
  end

  def index
    @trips = current_user.trips.order(created_at: :desc)
  end

  def show
    @trip = Trip.find(params[:id])
    @participants = Participant.where(trip_id: params[:id])
    @participants_list = @trip.participants_list
    @news = News.where(trip_id: @trip.id).order(created_at: :desc).first(10)
    @rooms = Room.where(trip: @trip)
    if @trip.choosen? ||@trip.booked?
      @choosen_room = Room.find(@trip.choosen_room_ids.first)
    elsif @trip.draw?
      @choosen_rooms = @trip.choosen_room_ids.map { |id| Room.find(id) }
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    redirect_to trips_path
  end

  def edit_destination
    @trip = Trip.find(params[:id])
    @participants = @trip.participants
    @participants_list = @trip.participants_list
  end

  def reset_dates
    @trip = Trip.find(params[:id])
    @trip.update(start_date: nil, end_date: nil)

    redirect_to trip_path(@trip)
  end

  def edit_dates
    @trip = Trip.find(params[:id])
    @participants = @trip.participants
    @participants_list = @trip.participants_list
  end

  def update
    @trip = Trip.find(params[:id])
    if @trip.update(trip_params)
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Trip", imageable_id: @trip.id)
      redirect_to trip_path(@trip)
    else
      redirect_back fallback_location: @trip, alert: "#{@trip.errors.full_messages[0]}"
    end
  end

  def start_propositions
    @trip = Trip.find(params[:trip_id])
    @trip.start_propositions!
    redirect_to trip_rooms_path(@trip)
  end

  def start_votes
    @trip = Trip.find(params[:trip_id])
    @trip.start_votes!
    redirect_to trip_rooms_path(@trip)
  end

  def set_as_booked
    @trip = Trip.find(params[:trip_id])
    @trip.set_as_booked!
    redirect_to trip_rooms_path(@trip)
  end

  def back_propositions
    @trip = Trip.find(params[:trip_id])
    @trip.participants.each { |participant| participant.update(room_votes: []) }
    @trip.back_propositions!
    redirect_to trip_rooms_path(@trip)
  end

  def back_votes
    @trip = Trip.find(params[:trip_id])
    @trip.participants.each { |participant| participant.update(room_votes: []) }
    @trip.back_votes!
    redirect_to trip_rooms_path(@trip)
  end

  def reset_vote
    @trip = Trip.find(params[:trip_id])
    @participant = current_user.participant(@trip)
    @participant.update(room_votes: [])
    redirect_to trip_rooms_path(@trip)
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :destination, :room_state, :aasm_state, :photo_url)
  end
end
