class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def time_since_created
    # secondes since creation
    time_ellapsed = (Time.now - created_at).to_i
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
end
