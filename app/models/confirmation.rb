class Confirmation < ActiveRecord::Base
  belongs_to  :user, :foreign_key => "from_user"
  belongs_to  :assignment
  delegate    :swapset, :to => :assignment
  delegate    :swap, :to => :swapset
  
  attr_accessor :from
  
  def from=(user)
    self.from_user = user.id
    @from = user
  end

end
