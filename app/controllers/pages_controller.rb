class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :waiting_confirmation ]

  def waiting_confirmation
  end

  def room_process
  end
end
