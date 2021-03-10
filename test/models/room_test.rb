require "test_helper"

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "get_id method return the good id" do
    room = Room.new(url: "https://www.airbnb.fr/rooms/34108527?source_impression_id=p3_1615369716_zV1BYbb6s7vxqnyD&guests=1&adults=1")
    room.get_id
    assert_equal "34108527", room.web_id
  end
  
end
