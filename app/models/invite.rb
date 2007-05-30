gem 'uuidtools'
require 'uuidtools'

class Invite < ActiveRecord::Base
  belongs_to  :user,
              :foreign_key => 'from_user'
  belongs_to  :accepted_by, :class_name => "User",
              :foreign_key => 'accepted_by'
              
  validates_format_of :to_email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i,
                      :message => "That's not a valid email."
  validates_presence_of :from_user
  
  def from=(from)
    self.from_user = from.id
  end
  
  def to=(to)
    self.to_email = to.to_s.downcase
  end
  
  def to
    self.to_email
  end
  
  def deliver
    update_attribute :status, 'open'
  end
  
  def accept(user)
    if 'open' == self.status
      self.status = 'accepted'
      self.accepted_at = Time.now
      self.accepted_by = user
      save
    else
      raise "Invite #{self.uuid} already accepted."
    end
  end
  
  def open?
    'open' == status
  end
  
  def accepted?
    'accepted' == status
  end
  
  def is_unique?
    self.class.count(:conditions => { :to_email => to_email, :status => 'open' }) == 0
  end
  
  def before_create
    self.uuid = UUID.random_create.to_s.gsub(/\W/, '').upcase
    self.status = 'pending'
  end
  
  def validate_on_create
    errors.add(:to_email, "#{to_email} is already a member") if User.count(:conditions => {:email => to_email}) > 0
  end
end
