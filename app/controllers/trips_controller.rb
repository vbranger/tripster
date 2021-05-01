class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    @trip.save
    Participant.create!(trip_id: @trip.id, user_id: current_user.id)
    News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Trip", imageable_id: @trip.id)
    redirect_to trips_path
  end

  def index
    @trips = current_user.trips.order(created_at: :desc)
  end

  def show
    @trip = Trip.find(params[:id])
    @participants = Participant.where(trip_id: params[:id])
    @participants_list = @trip.participants_list
    @news = News.where(trip_id: @trip.id).order(created_at: :desc)
    @rooms = Room.where(trip: @trip)
  end

  def destroy
    @trip = Trip.find(params[:id])
    @trip.destroy

    redirect_to trips_path
  end

  def edit_destination
    @trip = Trip.find(params[:id])
  end

  def reset_dates
    @trip = Trip.find(params[:id])
    @trip.update(start_date: nil, end_date: nil)

    redirect_to trip_path(@trip)
  end

  def edit_dates
    @trip = Trip.find(params[:id])
  end

  def update
    @trip = Trip.find(params[:id])
    @trip.update(trip_params)
    News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Trip", imageable_id: @trip.id)
    redirect_to trip_path(@trip)
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :destination)
  end
end
