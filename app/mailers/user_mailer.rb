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

  def notify_invitation(invite)
    @recipient = invite.recipient
    @sender = invite.sender
    @trip = invite.trip
    mail to: @recipient.email, subject: "You received an invitation"
  end

  def new_user_invite(invite, url)
    @url = url
    @sender = invite.sender
    @trip = invite.trip

    mail to: invite.email, subject: "You received an invitation for a Tripster"
  end

  def new_room_added(maker, recipient, room)
    @maker = maker
    @recipient = recipient.user
    @room = room
    @trip = room.trip
    p @unnoted_rooms = @trip.rooms.select { |y| y.reviews.where(user_id: @recipient.id).empty? } 
    @unnoted_rooms.reject!{ |x| x == room }
    @unnoted_rooms.sort_by { |a| [a.avg_score, a.reviews.count] }.reverse.first(2)
    mail to: @recipient.email, subject: "#{maker.first_name} a ajouté #{room.name}"
  end
end
