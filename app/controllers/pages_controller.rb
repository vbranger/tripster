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
  end
end
