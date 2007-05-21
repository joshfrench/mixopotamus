class User < AuthenticatedUser
  has_many  :favorites, :foreign_key => "from_user"
  has_many  :stars, :class_name => "Favorite", :foreign_key => "to_user"
  has_many  :assignments
  has_many  :swapsets,
            :through => :assignments
  has_many  :registrations do
              def find_by_swap(swap)
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
    self.assignments.find_by_position(p).swapset
  end
            
  def favorite(user, swapset)
    Favorite.create(:from => self, :to => user, :swapset => swapset)
  end
  
  def favorited(user, swapset)
    favorites.find_by_swapset_id_and_to_user(swapset.id, user.id)
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
  
  def confirmed_for?(swap)
    registrations.find_by_swap_id(swap.id).confirmations > 0
  end
  
  def ok_to_play?
    (swaps.last.nil? || swaps.last == Swap.current) ? true : confirmed_for?(swaps.last)
  end
  
  def confirm_for(swap)
    registrations.find_by_swap_id(swap.id).add_confirmation
  end
  
  def before_create
    self.invite_count = 0
  end
end
