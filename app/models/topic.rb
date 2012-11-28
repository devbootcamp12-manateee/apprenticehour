# == Schema Information
#
# Table name: topics
#
#  id          :integer          not null, primary key
#  description :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Topic < ActiveRecord::Base
  attr_accessible :description

  has_many :meetings

  validates :description,
    :presence => true,
    :uniqueness => true,
    :length => { maximum: 30 }
end
