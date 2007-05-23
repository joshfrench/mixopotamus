class Confirmation < ActiveRecord::Base
  belongs_to  :user, :foreign_key => "from_user"
  belongs_to  :assignment
  delegate    :swapset, :swap, :to => :assignment
  
  attr_accessor :from
  
  validates_presence_of :from_user, :assignment
  
  def from=(user)
    self.from_user = user.id
    @from = user
  end

end
