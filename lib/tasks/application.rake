namespace :app do
  desc "Make new swap"
  task :new_swap => [:environment] do
    Swap.create :deadline => SWAP_LENGTH.from_now
  end
  
  desc "Populate swap with sets"
  task :make_sets => [:environment] do
    swap = Swap.current
    swap.initialize_set(swap.users, SWAPSET_SIZE, Swapset.find(:all).map(&:users))
    swap.solve.each do |users|
      swapset = swap.swapsets.create
      users.each { |user| swapset.assign user }
    end
    # fill short set, if it exists
    swap.swapsets.reject { |set| SWAPSET_SIZE == set.size }.each do |short_set|
      swap.fill_set short_set
    end
  end
  
end