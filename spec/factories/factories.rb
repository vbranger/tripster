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
    user { User.new }
  end
  
end