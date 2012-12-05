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

class Meeting < ActiveRecord::Base
  attr_accessible :description, :neighborhood, :status, :topic_id, :mentor_id
  # statuses: available, accepted, matched, completed, cancelled

  belongs_to :mentee, :class_name => "User"
  belongs_to :mentor, :class_name => "User"
  belongs_to :topic

  validates :mentee_id, :status, :topic_id,
    :presence => true
  validates :description,  
    :presence => true, 
    :length => { maximum: 200 }
  validates :neighborhood,
    :presence => true,
    :length => { maximum: 64 }

  scope :available,     where(:status => 'available')
  scope :matched,       where(:status => 'matched')
  scope :accepted,      where(:status => 'accepted')
  scope :not_cancelled, where('status != ?', 'cancelled')

  scope :sort_by_created_desc, order("created_at DESC")
  scope :sort_by_status,       order("CASE WHEN (status = 'available') \
    THEN 1 WHEN (status = 'accepted') THEN 2 ELSE 3 END ASC")
  
  scope :filter_by_topic, lambda { |topic| where("topic_id = ?", topic.id) }

  def self.update_accepted_meetings
    Meeting.expired_acceptance.each(&:make_available)
  end

  def completable_for?(user)
    status == 'matched' && (mentor == user || mentee == user)
  end

  def available_for?(user)
    status == 'available' && mentee != user
  end

  def cancellable_for?(user)
    status != 'completed' && status != 'cancelled' && mentee == user
  end

  def make_available
    update_attributes(:status => 'available', :mentor => nil)
  end

private
  def self.expired_acceptance
    accepted.where('updated_at < ?', 10.minutes.ago)
  end
end
