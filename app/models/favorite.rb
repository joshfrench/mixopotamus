class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :assignment
  attr_accessor :from, :to, :swapset
  
  delegate :swapset_id, :user_id,  :to => :assignment
  
  validates_presence_of :from_user
  validates_presence_of :assignment_id
  
  def from=(from)
    self.from_user = from.id
    @from = from
  end
  
  def before_validation
    self.assignment_id = Assignment.find_by_swapset_id_and_user_id(@swapset.id, @to.id).id
  end

end
