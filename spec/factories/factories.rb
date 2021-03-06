require 'faker'

FactoryBot.define do
  factory :user do
    first_name { Faker::Name.first_name }
    last_name  { Faker::Name.last_name }
    email { Faker::Internet.unique.email }
    password { '123456' }

    before(:create) do |user|
      user.skip_confirmation!
    end
  end

  factory :trip do
    name { 'test' }
    user { create(:user) }

    after(:create) do |trip|
      create(:participant, trip: trip, user: trip.user)
    end
  end

  factory :room do
    trip { create(:trip) }
    name { Faker::Address.street_name }
    price { rand(50.0..500.0).round(2) }
    url { "a" }
    avg_score { 0.0 }
  end

  factory :review do
    content { "blabla" }
    room { create(:room) }
    user { create(:user) }
    score { rand(0..5) }
  end

  factory :participant do
    trip { create(:trip) }
    user { create(:user) }
  end
end