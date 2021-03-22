class UserMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.welcome.subject
  #
  def welcome(user)
    @user = user
    mail to: user.email, subject: "Welcome to Tripster"
  end

  def notify_invitation(user, trip)
    @user = user
    @trip = trip
    mail to: user.email, subject: "You received an invitation"
  end
end
