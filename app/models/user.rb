class User < AuthenticatedUser
  has_many  :favorites, :foreign_key => "from_user" do
              def by_user_and_set(user,set)
                find_by_assignment_id Assignment.find_by_swapset_id_and_user_id(set.id, user.id).id
              end
            end
  has_many  :stars, :through => :assignments, :source => :user, :class_name => "Favorite"
  has_many  :assignments
  has_many  :swapsets,
            :through => :assignments do
              def by_swap(swap)
                find_by_swap_id(swap.id)
              end
            end
  has_many  :confirmations,
            :through => :assignments
  has_many  :confirms_given, :class_name => "Confirmation", 
            :foreign_key => :from_user do
              def by_user_and_set(user,set)
                assign = Assignment.find_by_swapset_id_and_user_id(set.id, user.id)
                find_by_assignment_id(assign.id)
              end
              def by_assignment(assign)
                find_by_assignment_id(assign.id)
              end
            end
  has_many  :registrations do
              def by_swap(swap)
                find_by_swap_id(swap.id)
              end
            end
  has_many  :swaps,
            :through => :registrations
  has_many  :invites, :foreign_key => "from_user"
            
  def <=>(other)
    self.id <=> other.id
  end
  
  def find_swapset_by_position(p)
    if assignment = self.assignments.find_by_position(p)
      return assignment.swapset
    end
  end
            
  def favorite(user, swapset)
    Favorite.create(:from => self, :to => user, :swapset => swapset)
  end
  
  def favorited(user, swapset)
    favorites.by_user_and_set(user, swapset)
  end
  
  def give_invite
    update_attribute(:invite_count, invite_count+1)
  end
  
  def create_invite(email)
    raise "Out of invites" if self.invite_count < 1
    Invite.create(:from => self, :to => email)
  end
  
  def send_invite(invite)
    if self == invite.user && 'pending' == invite.status
      invite.deliver
      update_attribute(:invite_count, invite_count-1) # unless 1 == id
    else
      raise "Unable to send invite"
    end
  end
  
  def ok_to_play?
    (swaps.last.nil? || swaps.last == Swap.current) ? true : confirmed_for?(swaps.last)
  end
  
  def confirmed_for?(swap)
    swapsets.by_swap(swap).assignments.find_by_user_id(id).confirmations.count > 0 || false
  rescue  
    false
  end
  
  def before_create
    self.invite_count = 0
  end
end
