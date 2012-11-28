# == Schema Information
#
# Table name: users
#
#  id       :integer          not null, primary key
#  uid      :string(255)
#  provider :string(255)
#  name     :string(255)
#  email    :string(255)
#  gravatar :string(255)
#

require 'spec_helper'

describe User do
	# how/do we valid association with meeting (via mentee and mentor)?
	it { should have_many :mentor_meetings }
	it { should have_many :mentee_meetings }
	
	it { should validate_presence_of :uid }
	it { should validate_presence_of :provider }
	it { should validate_presence_of :name }
	it { should validate_presence_of :email }
	it { should validate_presence_of :gravatar }

	it { should validate_uniqueness_of :email }

	it { should_not allow_mass_assignment_of :uid }
	it { should_not allow_mass_assignment_of :provider }
	it { should_not allow_mass_assignment_of :name }
	it { should_not allow_mass_assignment_of :email }
	it { should_not allow_mass_assignment_of :gravatar }

	describe '#mentee_meetings' do
		it 'returns a list of meetings for which the user is the mentee' do
			user = FactoryGirl.create(:user)
			mentee_meeting = FactoryGirl.create(:meeting, :mentee => user)
			other_meeting = FactoryGirl.create(:meeting)

			user.mentee_meetings.should eq mentee_meeting
		end
	end

	describe '#mentor_meetings' do
		it 'returns a list of meetings for which the user is the mentor' do
			user = FactoryGirl.create(:user)
			mentor_meeting = FactoryGirl.create(:meeting, :mentor => user)
			other_meeting = FactoryGirl.create(:meeting)
			
			user.mentor_meetings.should eq mentor_meeting
		end
	end
end
