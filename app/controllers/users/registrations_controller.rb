class Users::RegistrationsController < Devise::RegistrationsController

  protected

  def after_inactive_sign_up_path_for(resource)
    waiting_confirmation_path
  end

end