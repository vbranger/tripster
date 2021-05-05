class RoomsController < ApplicationController

  respond_to :js, :html, :json

  def new
    @trip = Trip.find(params[:trip_id])
    @room = Room.new
    @participants = @trip.participants
    @participants_list = @trip.participants_list
  end

  def create
    @room = Room.new(room_params)
    @trip = Trip.find(params[:trip_id])
    @room.trip = @trip
    @room.universal_scrap
    if @room.url.include? "airbnb"
      @room.website = "airbnb"
      @room.get_airbnb_id
      p "starting scrap"
      @room.scrap_airbnb
      p "ended scrap"
    elsif @room.url.include? "abnb"
      @room.website = "airbnb"
      @room.convert_url
      @room.get_airbnb_id
      p "starting scrap"
      @room.scrap_airbnb
      p "ended scrap"
    elsif @room.url.include? "hmwy"
      @room.website = "abritel"
      @room.convert_url
      p "starting scrap"
      @room.scrap_abritel
      p "ended scrap"
    elsif @room.url.include? "abritel.fr"
      @room.website = "abritel"
      p "starting scrap"
      @room.scrap_abritel
      p "ended scrap"
    elsif @room.url.include? "www.coinsecret.com"
      @room.universal_scrap
    end
    if @room.save
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Room", imageable_id: @room.id)
      redirect_to trip_rooms_path(@trip)
    else
      render :new
    end
  end

  def show
    @trip = Trip.find(params[:trip_id])
    @room = Room.find(params[:id])
    @participants = @trip.participants
    @participants_list = @trip.participants_list
    @review = Review.where(user_id: current_user.id, room_id: @room.id).first
    @reviews = @room.reviews.order(created_at: :desc)
  end

  def like
    @trip = Trip.find(params[:trip_id])
    @room = Room.find(params[:id])
    if params[:format] == 'like'
      @room.liked_by current_user
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Room", imageable_id: @room.id)
    elsif params[:format] == 'unlike'
      @room.unliked_by current_user
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}#un#{params[:action]}", imageable_type: "Room", imageable_id: @room.id)
    end
    redirect_to request.referrer
  end

  def destroy
    @trip = Trip.find(params[:trip_id])
    @room = Room.find(params[:id])
    @room.destroy

    redirect_to trip_rooms_path(@trip)
  end

  def index
    @trip = Trip.find(params[:trip_id])
    @participants = @trip.participants
    @participants_list = @trip.participants_list
    if params[:query] == ['top_rated']
      @rooms = Room.where(trip: @trip).order(avg_score: :desc)
    elsif params[:query] == ['newest']
      @rooms = Room.where(trip: @trip).order(created_at: :desc)
    else
      @rooms = Room.where(trip: @trip).order(avg_score: :desc)
    end
  end
  

  private

  def room_params
    params.require(:room).permit(:url)
  end

end
