class Assignment < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :swapset
  has_many    :confirmations
  
  delegate :swap, :to => :swapset
  
  acts_as_list :scope => :user_id
  
  alias_method :next, :lower_item
  alias_method :previous, :higher_item
  
  validates_presence_of :swapset_id
  validates_presence_of :user_id
  
  def after_create
    move_to_top
  end
  
end
