class ReviewsController < ApplicationController
  def new
    # we need @restaurant in our `simple_form_for`
    
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @review = Review.new
  end

  def create
    @review = Review.new(review_params)
    @room = Room.find(params[:room_id])
    @trip = @room.trip
    @review.room = @room
    if @review.save
      redirect_to trip_room_path(@trip, @room)
    else
      render :new
    end
  end

  private

  def review_params
    params.require(:review).permit(:score, :content)
  end



end
