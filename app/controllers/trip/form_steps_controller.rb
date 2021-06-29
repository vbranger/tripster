class Trip::FormStepsController < ApplicationController
  include Wicked::Wizard
  # on récupère les steps qu'on a déclaré dans le model trip.rb
  steps *Trip.form_steps

  def show
    @trip = Trip.find(params[:trip_id])
    render_wizard
  end

  def update
    @trip = Trip.find(params[:trip_id])
    @trip.update(trip_params(step))
    if next_step == "wicked_finish"
      redirect_to @trip
    else
      render_wizard @trip
    end
  end

  private

  def trip_params(step)
  	permitted_attributes = case step
  	  when "name"
  	    [:name]
  	  when "destination"
  	    [:destination, :photo_url]
  	  when "dates"
  	    [:start_date, :end_date]
  	  end

  	params.require(:trip).permit(permitted_attributes).merge(form_step: step)
  end

end
