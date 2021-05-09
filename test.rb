def calculate_choosen_room(participants)
  # participants_votes = participants.map {|participant| participant.room_votes}
  participants_votes = participants
  hash = calculation_inner(participants_votes)
  best_score = get_best_score(hash)
  find_rooms_with_best_score(hash, best_score)
end

def calculation_inner(participants_votes)
  rooms = {}

  participants_votes.each do |votes|
    votes.each_with_index do |id, index|
      rooms.has_key?(id) ? rooms[id] += index : rooms[id] = index
    end
  end
  rooms
end

participants_votes = [[1, 2, 3], [1, 3, 2], [2, 3, 1], [2, 1, 3]]

def get_best_score(hash)
  hash.values.min_by{ |x| x }
end

def find_rooms_with_best_score(hash, best_score)
  rooms_ids = []
  hash.select { |k, v| v == best_score}.keys.each { |k| rooms_ids << k }
end

p calculate_choosen_room(participants_votes)