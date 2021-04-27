class ParticipantsController < ApplicationController

  def new
    @participant = Participant.new
    @trip = params[:trip]
  end

  # probablement obsolète
  def create
    user = User.where(email: params[:email])
    unless user.empty?
      @participant = Participant.new(user_id: user.first.id, trip_id: params[:trip])
      @trip = Trip.find(params[:trip])
      if @participant.save
        UserMailer.notify_invitation(@participant.user, @trip).deliver_now
        redirect_to trip_path(@participant.trip)
      end
    else
      @participant = Participant.new
      @trip = params[:trip]
      render 'new'
    end
  end
  # fin probablement obsolète

  def destroy
    @participant = Participant.find(params[:id])
    @participant.destroy
    News.create!(user: @participant.user, trip_id: @participant.trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Participant", imageable_id: @participant)
    redirect_to trip_path(@participant.trip)
  end

  private

  def participant_params
    params.require(:participant).permit(:user_id, :trip_id)
  end

end
