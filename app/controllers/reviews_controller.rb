class ReviewsController < ApplicationController

  
  def new
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @review.room = @room
    @review.user = current_user
    if @review.save
      News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Review", imageable_id: @review.id)
      redirect_to trip_room_path(@trip, @room)
    else
      render :new
    end
  end

  def edit
    @review = Review.where(user_id: current_user.id, room_id: params[:room_id]).first
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @participants = @trip.participants
    @participants_list = @trip.participants_list
  end

  def update
    @review = Review.find(params[:id])
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @participants = @trip.participants
    @participants_list = @trip.participants_list

    @review.update(review_params)
    News.create!(user: current_user, trip_id: @trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Review", imageable_id: @review.id)
    @review.update_avg_score
    redirect_to trip_room_path(@trip, @room)
  end

  private

  def review_params
    params.require(:review).permit(:score, :content)
  end

end
