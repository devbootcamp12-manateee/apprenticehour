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


class User < ActiveRecord::Base
  validates :uid,      :presence => true
  validates :provider, :presence => true
  validates :email,    :presence => true,
                       :uniqueness => true
  validates :gravatar, :presence => true

  attr_accessible :email

  has_many :mentor_meetings,
           :class_name => 'Meeting',
           :foreign_key => 'mentor_id'

  has_many :mentee_meetings,
           :class_name => 'Meeting',
           :foreign_key => 'mentee_id'

  before_save :create_remember_token

  def self.from_oauth(auth)
    where(auth.slice(:provider, :uid)).first_or_initialize.tap do |user|
      user.provider         = auth.provider
      user.uid              = auth.uid
      user.name             = auth.info.name
      if auth.info.email.empty? && user.email.nil?
        user.email = user.name
      else
        user.email = user.email || auth.info.email
      end
      user.gravatar         = auth.info.image
      user.oauth_token      = auth.credentials.token
      user.oauth_expires_at = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
      user.save!
    end
  end

  def meetings
    Meeting.where('mentor_id = ? or mentee_id = ?', id, id)
  end

private
  def create_remember_token
    self.remember_token = SecureRandom.urlsafe_base64
  end
end