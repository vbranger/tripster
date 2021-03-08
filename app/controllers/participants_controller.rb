class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new
    @trip = params[:trip]
  end

  def create
    @participant = Participant.new(participant_params)
    @participant.save
    redirect_to trip_path(@participant.trip)
  end

  private

  def participant_params
    params.require(:participant).permit(:user_id, :trip_id)
  end

end
