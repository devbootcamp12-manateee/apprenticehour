# == Schema Information
#
# Table name: meetings
#
#  id           :integer          not null, primary key
#  mentee_id    :integer
#  mentor_id    :integer
#  topic_id     :integer
#  description  :string(255)
#  neighborhood :string(255)
#  status       :string(255)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

require 'spec_helper'

describe Meeting do
  it { should belong_to(:topic) }
  it { should belong_to(:mentee) }
  it { should belong_to(:mentor) }

  it { should validate_presence_of(:mentee_id) }
  it { should validate_presence_of(:topic_id) }
  it { should validate_presence_of(:description) }
  it { should validate_presence_of(:neighborhood) }
  it { should validate_presence_of(:status) }

  it { should ensure_length_of(:description).is_at_most(200) }
  it { should ensure_length_of(:neighborhood).is_at_most(64) } # maybe not?

  it { should_not allow_mass_assignment_of :mentee_id }

  describe 'scopes' do
    describe '.available' do
      it 'returns all meetings with a status of available' do
        available_meeting = create(:meeting)
        matched_meeting = create(:matched_meeting)
        Meeting.available.should eq [available_meeting]
      end
    end

    describe '.matched' do
      it 'returns all meetings with a status of matched' do
        matched_meeting = create(:matched_meeting)
        unmatched_meeting = create(:meeting)
        Meeting.matched.should eq [matched_meeting]
      end
    end

    describe '.sort_by_created_desc' do
      it 'sorts by creation date desc' do
        old_meeting = create(:meeting, :created_at => 10.weeks.ago)
        new_meeting = create(:meeting, :topic_id => 2)
        Meeting.sort_by_created_desc.should eq [new_meeting, old_meeting]
      end
    end

    describe '.filter_by_topic' do
      it 'returns all meetings with the provided topic' do
        regular_meeting = create(:meeting)
        rails_topic = create(:topic, :description => 'rails')
        rails_meeting = create(:meeting, :topic => rails_topic)
        Meeting.filter_by_topic(rails_topic).should eq [rails_meeting]
      end
    end
  end
end
