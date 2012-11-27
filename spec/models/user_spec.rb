require 'spec_helper'

describe User do
	# how/do we valid association with meeting (via mentee and mentor)?
	
	it { should validate_presence_of :uid }
	it { should validate_presence_of :provider }
	it { should validate_presence_of :name }
	it { should validate_presence_of :email }
	it { should validate_presence_of :gravatar_href }

	it { should validate_uniqueness_of :email }

	describe '#mentee_meetings' do
		it 'returns a list of meetings for which the user is the mentee'
	end

	describe '#mentor_meetings' do
		it 'returns a list of meetings for which the user is the mentor'
	end
end