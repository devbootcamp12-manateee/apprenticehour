# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  uid              :string(255)
#  provider         :string(255)
#  name             :string(255)
#  email            :string(255)
#  gravatar         :string(255)
#  oauth_token      :string(255)
#  oauth_expires_at :datetime
#  remember_token   :string(255)
#

require 'spec_helper'

describe User do
	# how/do we valid association with meeting (via mentee and mentor)?
	it { should have_many :mentor_meetings }
	it { should have_many :mentee_meetings }
	
	it { should validate_presence_of :uid }
	it { should validate_presence_of :email }
	it { should validate_presence_of :provider }
	it { should validate_presence_of :gravatar }
	
	it { should validate_uniqueness_of :email }

	it { should_not allow_mass_assignment_of :uid }
	it { should_not allow_mass_assignment_of :provider }
	it { should_not allow_mass_assignment_of :name }
	it { should_not allow_mass_assignment_of :gravatar }

	describe 'remember_token' do
		it 'exists' do
			user = create(:user)
			user.remember_token.should_not be_blank
		end
	end

	describe '#mentee_meetings' do
		it 'returns a list of meetings for which the user is the mentee' do
			user = create(:user)
			mentee_meeting = create(:meeting, :mentee => user)
			other_meeting  = create(:meeting)

			user.mentee_meetings.should eq [mentee_meeting]
		end
	end

	describe '#mentor_meetings' do
		it 'returns a list of meetings for which the user is the mentor' do
			user = FactoryGirl.create(:user)
			mentor_meeting = FactoryGirl.create(:matched_meeting, :mentor => user)
			other_meeting = FactoryGirl.create(:meeting)
			
			user.mentor_meetings.should eq [mentor_meeting]
		end
	end

	describe '.from_oauth' do
		let(:fakeauth) { Hashie::Mash.new(:provider => 'github',
				                              :uid => '12345',
				                              :info => Hashie::Mash.new(:name => 'Bob',
				                              	                        :email => 'bob@bob.com',
				                              	                        :image => 'sasdad'),
				                              :credentials => Hashie::Mash.new(:token => '1234',
																				                               :expires_at => Time.now)) }

		it 'creates a new user from github oauth information' do
			expect { User.from_oauth(fakeauth)}.to change(User, :count).by(1)
		end

		it 'updates existing user with new data from github' do
			fakeauth.info.name = 'Joe'
			User.from_oauth(fakeauth)
			User.last.name.should eq 'Joe'
		end
	end
end
