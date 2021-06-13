require 'rails_helper'

RSpec.describe TripsController, type: :controller do
  describe 'create' do
    it 'successfully creates a new trip' do
      trip = create(:trip, name: 'new trip')
      expect(trip.name).to eq('new trip')
    end
  end
end
