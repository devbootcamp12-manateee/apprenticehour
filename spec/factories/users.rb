FactoryGirl.define do
  factory :user do
    uid { (0..9).to_a.shuffle[0..3].join }
    provider 'github'
    name { Faker::Name.name }
    email { Faker::Internet.email }
    gravatar 'http://www.brandoncole.com/profile%20photos/MANATEE/ki1892-florida_manatee_swimmer_brandon_cole.jpg'
  end
end