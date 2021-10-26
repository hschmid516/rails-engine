FactoryBot.define do
  factory :customer do
    first_name { Faker::Lorem.word }
    last_name { Faker::Lorem.word }
  end
end
