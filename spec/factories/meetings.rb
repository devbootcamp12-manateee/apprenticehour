FactoryGirl.define do
  factory :meeting do
    mentee_id { create(:user) }
    topic
    description "I need help with lambdas"
    neighborhood "mission"
    status "available"

    factory :cancelled_meeting do
      status "canceled"
      mentor_id { create(:user) }
    end

    factory :matched_meeting do
      status "matched"
      mentor_id { create(:user) }
    end
  end
end
