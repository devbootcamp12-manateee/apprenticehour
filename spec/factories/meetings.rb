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

    trait :cancelled do
      status "cancelled"
    end

    trait :matched do
      status "matched"
    end

    trait :accepted do
      status "accepted"
    end

    trait :old do
      updated_at 15.minutes.ago
    end

    factory :old_accepted_meeting, :traits => [:accepted, :old]
    factory :accepted_meeting, :traits => [:accepted]
    factory :cancelled_meeting, :traits => [:with_mentor, :cancelled]
    factory :matched_meeting, :traits => [:with_mentor, :matched]
  end
end
