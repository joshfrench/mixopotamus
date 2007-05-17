gem 'uuidtools'
require 'uuidtools'

class Invite < ActiveRecord::Base
  belongs_to  :user,
              :foreign_key => 'from'
              
  validates_presence_of :to_email
  validates_format_of :to_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  validates_presence_of :from_user
  
  def from=(from)
    self.from_user = from.id
  end
  
  def to=(to)
    self.to_email = to
  end
  
  def to
    self.to_email
  end
  
  def accept
    if 'open' == self.status
      self.status = 'accepted'
      self.accepted_at = Time.now
      save
    else
      raise "Invite #{self.uuid} already accepted."
    end
  end
  
  def before_create
    self.uuid = UUID.random_create.to_s.gsub(/\W/, '').upcase
    self.status = 'open'
  end
  
  def validate
    errors.add(:to_email, "#{to_email} is already a member") if User.count(:conditions => {:email => to_email}) > 0
  end
end
