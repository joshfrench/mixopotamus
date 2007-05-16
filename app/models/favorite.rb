class Favorite < ActiveRecord::Base
  belongs_to :user
  attr_accessor :from, :to
  
  validates_presence_of :swapset_id
  validates_presence_of :from_user
  validates_presence_of :to_user
  
  def from=(from)
    self.from_user = from.id
    @from = from
  end
  
  def to=(to)
    self.to_user = to.id
    @to = to
  end
  
  def swapset=(swapset)
    self.swapset_id = swapset.id
    @swapset = swapset
  end
  
  protected 
  def validate
    errors.add_to_base "Users not in same set" unless @swapset.users.include?(@from) && @swapset.users.include?(@to)
  end
end
