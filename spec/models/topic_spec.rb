require 'spec_helper'

describe Topic do
  it { should have_many(:meetings) }

  it { should validate_presence_of(:description) }
  it { should ensure_length_of(:description).is_at_most(30) }
  it { should validate_uniqueness_of(:description) }
end