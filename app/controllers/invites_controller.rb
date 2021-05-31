class InvitesController < ApplicationController

  def new
    @invite = Invite.new
    @trip = Trip.find(params[:trip])
    @participants = Participant.where(trip_id: params[:id])
    @participants_list = @trip.participants_list
  end

  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    @invite.sender_id = current_user.id
 # set the sender to the current user
    if @invite.save
      #if the user already exists
      if @invite.recipient != nil
        #send a notification email
        UserMailer.notify_invitation(@invite).deliver
        #Add the user to the user group
        @invite.recipient.trips.push(@invite.trip)
        # Add news
        News.create!(user: @invite.recipient, trip_id: @invite.trip.id, action_type: "#{params[:controller]}##{params[:action]}", imageable_type: "Participant", imageable_id: Participant.last)
        #redirect
        redirect_to trip_path(@invite.trip_id)
      else
        UserMailer.new_user_invite(@invite, new_user_registration_url(:invite_token => @invite.token)).deliver
        redirect_to trip_path(@invite.trip_id) #send the invite data to our mailer to deliver the email
      end
    else
      redirect_back fallback_location: trip_path(@invite.trip_id), alert: "#{@invite.errors.full_messages[0]}"
       # back to invite form with the error message created
    end


  end

  private

  def invite_params
    params.require(:invite).permit(:trip_id, :email)
  end

end
