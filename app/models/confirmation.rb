class Confirmation < ActiveRecord::Base
  belongs_to  :user
  belongs_to  :swapset
  delegate    :swap, :to => :swapset
  
  def from=(from)
    from_user = from.id
  end
end
