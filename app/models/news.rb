class News < ApplicationRecord
  belongs_to :user
  after_create :write_content
  
  def time_since_created
    # secondes since creation
    time_ellapsed = (Time.now - self.created_at).to_i
    p time_ellapsed

    if time_ellapsed < 60 # Moins d'une minute
      "Il y a #{time_ellapsed} #{time_ellapsed  <= 1 ? "seconde" : "secondes"}"
    elsif time_ellapsed < 3600 # Mois d'une heure
      time = time_ellapsed / 60
      "Il y a #{time} #{time <= 1 ? "minute" : "minutes"}"
    elsif time_ellapsed < 86_400 # Moins d'une journée
      time = time_ellapsed / 3_600
      "Il y a #{time} #{time <= 1 ? "heure" : "heures"}"
    else
      time = time_ellapsed / 86_400
      "Il y a #{time} #{time <= 1 ? "jour" : "jours"}"
    end
  end

  def write_content

    user_link = "<a href='/user/#{self.user.id}'>#{self.user.first_name}</a>"
    trip_link = "<a href='/trips/#{self.trip_id}'>#{Trip.find(self.trip_id).name}</a>"
    case self.action_type 
    when "trips#update"
      self.update(content: "#{user_link} a défini une nouvelle destination : #{Trip.find(self.trip_id).destination}")
    when "trips#create"
      self.update(content: "#{user_link} a créé #{trip_link}")
    when "invites#create"
      self.update(content: "#{user_link} a rejoint le trip")
    when "participants#destroy"
      self.update(content: "#{user_link} a quitté #{trip_link}")
    else
      self.update(content: "Autre info")
    end
  end

end
