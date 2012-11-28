class Meeting < ActiveRecord::Base
  attr_accessible :description, :mentee_id, :mentor_id, :neighborhood, :status, :topic_id

  belongs_to :mentee, :class_name => "User"
  belongs_to :mentor, :class_name => "User"
  belongs_to :topic

  validates :mentee_id, :status, :topic_id, :presence => true
  validates :description,  
    :presence => true, 
    :length => { maximum: 200 }
  validates :neighborhood,
    :presence => true,
    :length => { maximum: 64 }

  scope :available, where(:status => 'available')
  scope :matched, where(:status => 'matched')
  scope :sort_by_created_desc, order("created_at DESC")
  scope :filter_by_topic, lambda { |topic| where("topic_id = ?", topic.id) }
end
