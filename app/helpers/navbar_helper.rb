module NavbarHelper

  def login_link
    !(
      params[:controller].include?('users') ||
      params[:controller].include?('devise') ||
      params[:controller] == 'pages' && params[:action] == 'waiting_confirmation'
    )
  end

  def logo_tripster
    !user_signed_in? || params[:controller] == 'trips' && params[:action] == 'index' || params[:controller] == "pages"
  end

  def back_link(options = {})
    if go_to_trips_path
      trips_path
    elsif go_to_trip_path
      trip_path(options[:trip])
    elsif go_to_trip_rooms_path
      trip_rooms_path(options[:trip])
    elsif cancel_room_create
      trip_room_path(options[:trip], options[:room])
    elsif go_to_room_path
      trip_room_path(options[:trip], options[:room])
    end
  end

  def back_link_method
    if cancel_room_create
      :delete
    else
      :get
    end
  end

  def go_to_trips_path
    params[:controller] == 'trips' && (params[:action] == 'show' || params[:action] == 'new') ||
      params[:controller] == 'trip/form_steps'
  end

  def go_to_trip_path
    params[:controller] == 'rooms' && params[:action] == 'index' ||
      params[:controller] == 'trips' && (params[:action] == 'edit_destination' || params[:action] == 'edit_dates') ||
      params[:controller] == 'participants' && params[:action] == 'index'
  end

  def go_to_trip_rooms_path
    params[:controller] == 'rooms' && (params[:action] == 'show' || params[:action] == 'new')
  end

  def go_to_room_path
    params[:controller] == 'reviews'
  end

  def cancel_room_create
    params[:controller] == 'rooms' && params[:action] == 'edit'
  end
end
