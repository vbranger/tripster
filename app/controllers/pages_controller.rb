class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :waiting_confirmation, :home ]

  def waiting_confirmation
  end

  def room_process
  end

  def home
    if user_signed_in?
      redirect_to trips_path
    end

    @user_count = User.count.round(-1)
    @trip_count = Trip.count.round(-1)
    @review_count = Review.count.round(-1)
  end
end
