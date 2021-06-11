FactoryBot.define do
  factory :user do
    first_name { 'Victor' }
    last_name  { 'Branger' }
    password { '123456' }

    before(:create) do |user|
      user.skip_confirmation!
    end
  end

  factory :trip do
  end
  
end