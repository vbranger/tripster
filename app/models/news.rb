class News < ApplicationRecord
  belongs_to :user
  after_create :write_content
  
  def time_since_created
    # secondes since creation
    time_ellapsed = Time.now - self.created_at

    if time_ellapsed < 60 # Moins d'une minute
      "Il y a #{time_ellapsed.to_i} secondes"
    elsif time_ellapsed < 3600 # Mois d'une heure
      "Il y a #{time_ellapsed.to_i / 60} minutes"
    elsif time_ellapsed < 86400 # Moins d'une journée
      "Il y a #{time_ellapsed.to_i / 3600 } heures"
    else
      "Il y a #{time_ellapsed.to_i / 86400 } jours"
    end
  end

  def write_content
    case self.action_type 
    when "trips#update"
      self.update(content: "<a href='/user/#{self.user.id}'>#{self.user.first_name}</a> a défini une nouvelle destination : #{Trip.find(self.trip_id).destination}")
    when "trips#create"
      self.update(content: "#{self.user.first_name} a créé <a href='/trips/#{self.trip_id}'>#{Trip.find(self.trip_id).name}</a>")
    when "invites#create"
      self.update(content: "#{self.user.first_name} a rejoint #{Trip.find(self.trip_id).name}")
    when "participants#destroy"
      self.update(content: "#{self.user.first_name} a quitté #{Trip.find(self.trip_id).name}")
    else
      self.update(content: "Autre info")
    end
  end

end
