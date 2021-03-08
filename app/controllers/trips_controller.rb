class TripsController < ApplicationController

  def new
    @trip = Trip.new
  end

  def create
    @trip = Trip.new(trip_params)
    @trip.save

    redirect_to trips_path
  end

  def index
    @trips = Trip.all
  end

  def show
    @trip = Trip.find(params[:id])
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :destination)
  end
end
