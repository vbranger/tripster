class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.user_id = current_user.id
    @trip.save
    Participant.create!(trip_id: @trip.id, user_id: current_user.id)
    redirect_to trips_path
  end

  def index
    @trips = current_user.trips
  end

  def show
    @trip = Trip.find(params[:id])
    @participants = Participant.where(trip_id: params[:id])
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :destination)
  end
end
