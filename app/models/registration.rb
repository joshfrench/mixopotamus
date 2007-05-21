class Registration < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :swap
  acts_as_list :scope => :user_id
  alias_method :next, :lower_item
  alias_method :previous, :higher_item
  
  validates_presence_of :user_id
  validates_presence_of :swap_id
  
  def add_confirmation
    update_attribute(:confirmations, confirmations+1)
  end
  
  def before_create
    self.confirmations = 0
  end
  
  protected
  def validate
    errors.add_to_base "Duplicate registration" if self.class.count(:conditions => { :swap_id => swap_id, :user_id => user_id }) > 0
    if Swap.count(:conditions => { :id => swap_id }) < 1
      errors.add :swap, "Invalid Swap ID" 
    else
      errors.add_to_base "Registration closed" if Swap.find_by_id(swap_id).registration_deadline < Time.now
    end
    errors.add :user, "Did not complete last swap" unless User.find_by_id(user_id).ok_to_play?
  end
  
end