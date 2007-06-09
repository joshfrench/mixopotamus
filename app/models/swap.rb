class Swap < ActiveRecord::Base
  include Combinatorial
  
  has_many  :swapsets, :dependent => :destroy
  has_many :registrations, :dependent => :destroy
  has_many  :users,
            :through => :registrations
  has_many  :doubles,
            :through => :registrations,
            :source => :user,
            :conditions => ["double = ?", true]
            
  validates_presence_of :deadline
  
  acts_as_list
  
  alias_method :next, :lower_item
  alias_method :previous, :higher_item
  
  def registration_deadline
    deadline - (SWAP_LENGTH - REGISTRATION_LENGTH)
  end
  
  def mailing_reminder
    deadline - 1.week
  end
  
  def registration_reminder
    registration_deadline - 1.week
  end
  
  def open?
    registration_deadline > Time.now
  end
  
  def register(user, double=false)
    users << user unless (self.users.include?(user) || !user.ok_to_play?)
    reg = Registration.find_by_user_id_and_swap_id(user.id, id)
    reg.update_attribute(:double, double)
    reg
  rescue
    nil
  end
  
  def cancel_registration(user)
    registrations.find_by_user_id(user.id).destroy
  end
  
  def self.current
    find_by_position 1
  end
  
  def self.previous
    find_by_position 2
  end
  
  def after_create
    move_to_top
  end
  
  def make_sets
    initialize_set(users, SWAPSET_SIZE, Swapset.find(:all).map(&:users))
    solve.each do |users|
      swapset = swapsets.create
      users.each { |user| swapset.assign user }
    end
  end
  
  def fill_set(set)
    return set if SWAPSET_SIZE == set.users.size
    raise "No doubles in swap" if self.doubles.empty? 
    combinations = self.doubles.combinations(SWAPSET_SIZE - set.users.size)
    # random stroll through combinations,
    # in case there is an absurd number of them
    [combinations.size,1000].min.times do
      users = combinations.slice!(rand(combinations.size))
      next if (users & set.users).length > 0 # can't assign A to set that includes A
      k = Kset.new(self) << (set.users + users)
      if 0 == k.score
        @best = users
        break
      elsif k.score < self.max_score
        @best = users
        self.max_score = k.score
      end
    end
    
    if @best.nil?
      raise "Unable to fill short set with unique users"
    else
      @best.each { |user| set.assign user }
    end
  end
  
end
