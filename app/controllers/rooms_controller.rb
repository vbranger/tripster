class RoomsController < ApplicationController

  respond_to :js, :html, :json

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
    News.create!(user: current_user, trip: @trip, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Room", imageable_id: @trip)
    redirect_to trip_path(params[:trip_id])
  end

  def show
    @trip = Trip.find(params[:id])
    @room = Room.find(params[:trip_id])
  end

  def like
    @trip = Trip.find(params[:id])
    @room = Room.find(params[:trip_id])
    if params[:format] == 'like'
      @room.liked_by current_user
    elsif params[:format] == 'unlike'
      @room.unliked_by current_user
    end
    if params[:page] == 'trips'
      redirect_to trip_path(@trip)
    else
      redirect_to trip_room_path(@room)
    end
  end

  def destroy
    @trip = Trip.find(params[:id])
    @room = Room.find(params[:trip_id])
    @room.destroy

    redirect_to trip_path(@trip)
  end
  

  private

  def room_params
    params.require(:room).permit(:url)
  end

end
