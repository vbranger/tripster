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

  def new_user_invite(invite, url)
    @url = url
    @sender = invite.sender_id

    mail to: invite.email, subject: "You received an invitation for a Tripster"
  end
end
