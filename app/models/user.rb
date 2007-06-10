class User < AuthenticatedUser
  has_many  :favorites, 
            :foreign_key => 'from_user'
  has_many  :favorite_mixes, 
            :through => :favorites, 
            :source => :assignment
  has_many  :stars, :class_name => "Favorite", 
            :through => :assignments,
            :source => :favorites
  has_many  :assignments
  has_many  :swapsets,
            :through => :assignments
  has_many  :confirmations, 
            :foreign_key => :from_user
  # mixes_confirmed = other people's mixes you've confirmed receipt of
  has_many  :mixes_confirmed, 
            :through => :confirmations, 
            :source => :assignment
  has_many  :received_confirmations,
            :through => :assignments,
            :source => :confirmations
  has_many  :registrations, :dependent => :destroy
  has_many  :swaps,
            :through => :registrations
  has_many  :invites, 
            :foreign_key => "from_user"
  has_one   :accepted_invite, 
            :class_name => 'Invite',
            :foreign_key => 'accepted_by'
            
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
            
  def favorite(assignment)
    favorite_mixes << assignment unless favorite_mixes.include?(assignment)
  end
  
  def favorited?(assignment)
    favorite_mixes.include? assignment
  end
  
  def confirm(assignment)
    mixes_confirmed << assignment unless mixes_confirmed.include?(assignment)
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
    !(swap.confirmations & received_confirmations).empty?
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
  
  def self.recent_signups
    find(:all, 
         :conditions => ["created_at > ?", 1.week.ago-1.hour.ago], 
         :order => :created_at)
  end
  
  protected
  def make_reset
    self.reset = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end
end
