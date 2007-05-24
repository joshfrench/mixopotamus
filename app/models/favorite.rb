class Favorite < ActiveRecord::Base
  belongs_to :user, :foreign_key => "from_user"
  belongs_to :assignment 
  delegate :swapset_id, :user_id,  :to => :assignment
  
  attr_accessor :from, :to, :swapset
  
  validates_presence_of :from_user
  validates_presence_of :assignment_id
  
  def from=(from)
    self.from_user = from.id
    @from = from
  end
  
  def before_validation
    self.assignment ||= Assignment.find_by_swapset_id_and_user_id(@swapset.id, @to.id)
  end

end
