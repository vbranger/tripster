class InvitesController < ApplicationController
  
  def new
    @invite = Invite.new
    @trip = params[:trip]
  end

  def create
    @invite = Invite.new(invite_params) # Make a new Invite
    @invite.sender_id = current_user.id # set the sender to the current user
    if @invite.save
      #if the user already exists
      if @invite.recipient != nil 
        #send a notification email
        UserMailer.notify_invitation(@invite).deliver
        #Add the user to the user group
        @invite.recipient.trips.push(@invite.trip)
      else
        UserMailer.new_user_invite(@invite, new_user_registration_url(:invite_token => @invite.token)).deliver #send the invite data to our mailer to deliver the email
      end
    else
       # oh no, creating an new invitation failed
    end
    redirect_to trip_path(@invite.trip_id)
  end

  private

  def invite_params
    params.require(:invite).permit(:trip_id, :email)
  end

end
