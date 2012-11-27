# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :meeting do
    mentee_id 1
    mentor_id 1
    topic
    description "I need help with lambdas"
    neighborhood "mission"
    status "available"

    factory :canceled_meeting do
      status "canceled"
    end

    factory :matched_meeting do
      status "matched"
    end
  end
end
