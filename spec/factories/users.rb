FactoryGirl.define do
  factory :user do
    uid '1234'
    provider 'github'
    name { Faker::Name.name }
    email { Faker::Internet.email }
    gravatar 'a_pretty_picture'
  end
end