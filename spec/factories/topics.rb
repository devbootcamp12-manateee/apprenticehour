FactoryGirl.define do
  factory :topic do
    description { Faker::Lorem.word }
  end
end
