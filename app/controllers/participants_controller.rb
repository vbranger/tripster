class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new(trip_id: params[:trip_id])
  end

  def create
    @participant = Participant.new(participant_params)
    @participant.trip = params[:trip]
    @participant.save

    redirect_to trip_path(trip)
  end

  private

  def trip_params
    params.require(:trip).permit(:name, :start_date, :end_date, :destination)
  end

end
