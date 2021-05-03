class Users::RegistrationsController < Devise::RegistrationsController

  def new
    @token = params[:invite_token] #<-- pulls the value from the url query string
    build_resource
    yield resource if block_given?
    respond_with resource
  end

  def create
    build_resource(sign_up_params)
    resource.save
    @token = params[:invite_token]
    unless @token.nil?
      trip =  Invite.find_by_token(@token).trip #find the user group attached to the invite
      resource.trips.push(trip) #add this user to the new user group as a member
      News.create!(
        user: resource,
        trip_id: trip.id,
        action_type: "#{params[:controller]}##{params[:action]}",
        imageable_type: "Participant",
        imageable_id: Participant.last
      )

      # do normal registration things #
    end
    redirect_to waiting_confirmation_path
  end

  
  protected

  def after_inactive_sign_up_path_for(resource)
    waiting_confirmation_path
  end

end