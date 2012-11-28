FactoryGirl.define do
  factory :user do
    uid '1234'
    provider 'github'
    name 'John Doe'
    email 'john@doe.com'
    gravatar 'a_pretty_picture'
  end
end