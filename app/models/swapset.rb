class Swapset < ActiveRecord::Base
  has_many    :assignments, :dependent => :destroy
  has_many    :users,
              :through => :assignments
  has_many    :confirmations,
              :through => :assignments do
                def by_giver(user)
                  find_by_from_user(user.id)
                end
              end
  belongs_to  :swap
  
  def assign(user)
    users << user unless users.include?(user)
  end
  
end
