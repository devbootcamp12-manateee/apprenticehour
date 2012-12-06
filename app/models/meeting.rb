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
  VALID_TRANSITIONS = {
    nil         => ['available'],
    'available' => ['accepted', 'cancelled', 'available'],
    'accepted'  => ['matched', 'available', 'accepted'],
    'matched'   => ['cancelled', 'completed'],
    'cancelled' => ['cancelled'],
    'completed' => ['completed']
  }
  self.per_page = 20
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

  validate :valid_combination_of_mentor_id_and_status
  validate :valid_transition

  scope :available,     where(:status => 'available')
  scope :matched,       where(:status => 'matched')
  scope :accepted,      where(:status => 'accepted')
  scope :not_cancelled, where("status != 'cancelled'")

  scope :sort_by_created_desc, order("created_at DESC")
  scope :sort_by_status,       order("CASE WHEN (status = 'available') \
    THEN 1 WHEN (status = 'accepted') THEN 2 ELSE 3 END ASC")
  
  scope :filter_by_topic, lambda { |topic| where("topic_id = ?", topic.id) }

  def self.active(page=1)
    not_cancelled.sort_by_status.paginate(:page => page)
  end

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
    update_attributes(:status => 'available', :mentor_id => nil)
  end

  def valid_transition
    unless VALID_TRANSITIONS[status_was].include? status
      errors.add(:status, "transition is invalid")
    end
  end

  def send_match_message(message)
    if matched?
      MeetingRequestMailer.matched(self, message).deliver
      true
    elsif available? || accepted?
      false
    else
      true
    end
  end

  def matched?
    status == 'matched'
  end

  def available?
    status == 'available'
  end

  def accepted?
    status == 'accepted'
  end

private

  def self.expired_acceptance
    accepted.where('updated_at < ?', 10.minutes.ago)
  end

  def valid_combination_of_mentor_id_and_status
    if ((accepted? || available?) && mentor_id?)
      errors.add(:status, "another mentor has taken this meeting")
    end
  end
end
