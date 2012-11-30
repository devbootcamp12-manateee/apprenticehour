FactoryGirl.define do
  factory :meeting do
    mentee { create(:user) }
    topic
    description { Faker::Lorem.sentence }
    neighborhood { Faker::Lorem.word }
    status "available"

    trait :with_mentor do
      mentor { create(:user) }
    end

    trait :canceled do
      status "canceled"
    end

    trait :matched do
      status "matched"
    end

    factory :cancelled_meeting, :traits => [:with_mentor, :canceled]
    factory :matched_meeting, :traits => [:with_mentor, :matched]
  end
end
