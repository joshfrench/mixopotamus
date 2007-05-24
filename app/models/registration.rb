class Registration < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :swap
  acts_as_list :scope => :user_id
  alias_method :next, :lower_item
  alias_method :previous, :higher_item
  
  validates_presence_of :user_id
  validates_presence_of :swap_id
  
end