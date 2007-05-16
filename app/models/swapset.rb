class Swapset < ActiveRecord::Base
  has_many    :assignments, :dependent => :destroy
  has_many    :users,
              :through => :assignments
  belongs_to  :swap
  
  validates_presence_of :name
  
  def assign(user)
    assignments.create :user_id => user.id
  end
  
  def to_s
    { name => users.collect { |u| u.login } }
  end
end
