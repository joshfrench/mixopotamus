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
    deadline - 6.weeks
  end
  
  def register(user, double=false)
    registrations.create :user_id => user.id, :double => double
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
    list = File.read(File.expand_path(RAILS_ROOT + "/lib/vocab_list")).map { |word| word.chomp }
    initialize_set(users, SWAPSET_SIZE, Swapset.find(:all).map {|set| set.users})
    solve.each do |users|
      swapset = swapsets.create(:name => list.slice!(rand(list.size)) )
      users.each { |user| swapset.assign user }
    end
  end
  
  def fill_set(set)
    raise "No doubles in swap" if self.doubles.empty? 
    return set if SWAPSET_SIZE == set.users.size
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
