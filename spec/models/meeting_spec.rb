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

    describe '.sort_by_status' do
      it 'sorts by status, in order of: available, accepted, then the rest' do
        matched_meeting = create(:matched_meeting)
        available_meeting = create(:meeting)
        accepted_meeting = create(:accepted_meeting)

        Meeting.sort_by_status.should eq [available_meeting, accepted_meeting,
          matched_meeting]
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

    describe '.accepted' do
      it 'returns all meetings with a status of accepted' do
        accepted_meeting = create(:accepted_meeting)
        matched_meeting = create(:matched_meeting)
        cancelled_meeting = create(:cancelled_meeting)
        Meeting.accepted.should eq [accepted_meeting]
      end
    end

    describe '.not_cancelled' do
      it 'returns all meetings with a status not equal to cancelled' do
        accepted_meeting = create(:accepted_meeting)
        matched_meeting = create(:matched_meeting)
        cancelled_meeting = create(:cancelled_meeting)
        Meeting.not_cancelled.should eq [accepted_meeting, matched_meeting]
      end
    end
  end

  describe '.update_accepted_meetings' do
    context 'when updated more than 10 minutes ago' do
      it 'resets the meeting status to available' do
        old_accepted_meeting = create(:old_accepted_meeting)
        Meeting.update_accepted_meetings
        Meeting.first.status.should eq 'available'
      end
    end

    context 'when updated less than 10 minutes ago' do
      it 'changes nothing' do
        new_accepted_meeting = create(:accepted_meeting)
        Meeting.update_accepted_meetings
        Meeting.first.status.should eq 'accepted'
      end
    end
  end

  describe '#completable_for?' do
    context 'when meeting status is matched' do
      let!(:meeting) { create(:matched_meeting)}
      let(:mentee) { meeting.mentee }
      let(:mentor) { meeting.mentor }

      context 'when user is the mentee' do
        it "returns true" do
          meeting.completable_for?(mentee).should be_true
        end
      end

      context 'when user is the mentor' do
        it "returns true" do
          meeting.completable_for?(mentor).should be_true
        end
      end

      context 'when user is neither mentee nor mentor' do
        it "returns false" do
          user = create(:user)
          meeting.completable_for?(user).should be_false
        end
      end
    end

    context 'when meeting status is not matched' do
      it 'returns false' do
        meeting = create(:meeting)
        mentee = meeting.mentee
        meeting.completable_for?(mentee).should be_false
      end
    end 
  end

  describe '#available_for?' do
    context 'when available' do
      let!(:meeting) { create(:meeting)}
      let(:mentee) { meeting.mentee }

      context 'when mentee' do
        it 'returns false' do
          meeting.available_for?(mentee).should be_false
        end
      end

      context 'when not mentee' do
        it 'returns true' do
          user = create(:user)
          meeting.available_for?(user).should be_true
        end
      end
    end

    context 'when not available' do
      it 'returns false' do
        matched_meeting = create(:matched_meeting)
        user = matched_meeting.mentee
        matched_meeting.available_for?(user).should be_false
      end
    end
  end

  describe '#cancellable_for?' do
    let!(:meeting) { create(:meeting)}
    let(:mentee) { meeting.mentee }

    context 'when not completed and not cancelled' do
      context 'when mentee' do
        it 'returns true' do
          meeting.cancellable_for?(mentee).should be_true
        end
      end
      context 'when not mentee' do
        it 'returns false' do
          user = create(:user)
          meeting.cancellable_for?(user).should be_false
        end
      end
    end

    context 'when completed or cancelled' do
      it 'returns false' do
        cancelled_meeting = create(:cancelled_meeting)
        cancelled_meeting.cancellable_for?(mentee).should be_false
      end
    end
  end
end
