class User < AuthenticatedUser
  has_many  :favorites, :foreign_key => "from_user" do
              def by_user_and_set(user,set)
                find_by_assignment_id Assignment.find_by_swapset_id_and_user_id(set.id, user.id).id
              end
            end
  has_many  :stars, :class_name => "Favorite", 
            :finder_sql => 'SELECT favorites.* FROM favorites INNER JOIN assignments ON assignment_id = assignments.id WHERE assignments.user_id = #{id}'
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
  has_many  :registrations, :dependent => :destroy do
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
  
  def first_name
    login.split.first
  end
  
  def find_swapset_by_position(p)
    self.assignments.find_by_position(p).swapset
  rescue
    nil
  end
            
  def favorite(user, swapset)
    favorites << Favorite.create(:to => user, :swapset => swapset)
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
      update_attribute(:invite_count, invite_count-1) unless 1 == id
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
  
  def forgot_password
    @forgotten_password = true
    make_reset
  end
  
  def reset_password
    update_attributes(:reset => nil)
    @reset_password = true
  end
  
  def recently_forgot_password?
    @forgotten_password
  end
  
  def recently_reset_password?
    @reset_password
  end
  
  def before_create
    self.invite_count = 0
  end
  
  protected
  def make_reset
    self.reset = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
