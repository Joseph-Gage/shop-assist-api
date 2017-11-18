FactoryBot.define do
    factory :store do
      name { Faker::Lorem.word }
      address { Faker::Lorem.word }
    end
  end