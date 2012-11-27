require 'spec_helper'

describe Meeting do
	it { should belong_to(:tag) }
	it { should belong_to(:mentee) }
	it { should belong_to(:mentor) }

	it { should validate_presence_of(:mentee_id) }
	it { should validate_presence_of(:tag) }
	it { should validate_presence_of(:description) }
	it { should validate_presence_of(:neighborhood) }
	it { should validate_presence_of(:status) }

	it { should ensure_length_of(:description).is_at_most(200) }
	it { should ensure_length_of(:neighborhood).is_at_most(64) } # maybe not?

	it { should_not allow_mass_assignment_of :mentor }
	it { should_not allow_mass_assignment_of :mentee }

	# statuses = available, matched, completed, cancelled

	describe '#all_available' do
		it 'returns all meetings with a status of available'
	end

	describe '#all_matched' do
		it 'returns all meetings with a status of matched'
	end

	describe '#sort_by_created_desc' do
		it 'sorts by creation date desc'
	end

	describe '#filter_by_tag' do
		it 'returns all meetings with the provided tag'
	end
end
