class RoomsController < ApplicationController

  def new
    @trip = Trip.find(params[:trip_id])
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    @trip = Trip.find(params[:trip_id])
    @room.trip = @trip
    if @room.url.include? "airbnb"
      @room.website = "airbnb"
      @room.get_id
      p "starting scrap"
      @room.scrap
      p "ended scrap"
    end
    @room.save
    redirect_to trip_path(params[:trip_id])
  end

  def show
    @trip = Trip.find(params[:id])
    @room = Room.find(params[:trip_id])
  end

  def room_params
    params.require(:room).permit(:url)
  end

end
