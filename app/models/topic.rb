class Topic < ActiveRecord::Base
  attr_accessible :description

  has_many :meetings

  validates :description,
    :presence => true,
    :uniqueness => true,
    :length => { maximum: 30 }
end
