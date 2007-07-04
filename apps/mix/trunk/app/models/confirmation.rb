class Confirmation < ActiveRecord::Base
  belongs_to  :user, :foreign_key => "from_user"
  belongs_to  :assignment
  delegate    :swapset, :swap, :to => :assignment
  
  attr_accessor :from, :to, :swapset
  
  validates_presence_of :from_user, :assignment
  
  def to
    assignment.user
  end
  
  def from=(user)
    self.from_user = user.id
    @from = user
  end
  
  def before_validation_on_create
    self.assignment ||= Assignment.find_by_swapset_id_and_user_id(@swapset.id, @to.id)
  end

end
