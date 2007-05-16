class User < AuthenticatedUser
  has_many  :favorites, :foreign_key => "from_user"
  has_many  :stars, :class_name => "Favorite", :foreign_key => "to_user"
  has_many  :assignments
  has_many  :swapsets,
            :through => :assignments
  has_many  :registrations
  has_many  :swaps,
            :through => :registrations
            
  def <=>(other)
    self.id <=> other.id
  end
            
  def favorite(user, swapset)
    Favorite.create(:from => self, :to => user, :swapset_id => swapset)
  end
  
  def give_invite
    update_attribute(:invites, invites+1)
  end
  
  def invite(email)
    throw :out_of_invites if self.invites < 1
    i = Invite.create(:from => self, :to => email)
    update_attribute(:invites, invites-1) if i.valid?
    i
  end
  
  def confirmed_for?(swap)
    registrations.find_by_swap_id(swap.id).confirmations > 0
  end
  
  def confirm_for(swap)
    registrations.find_by_swap_id(swap.id).add_confirmation
  end
  
  def before_create
    self.invites = 0
  end
end
