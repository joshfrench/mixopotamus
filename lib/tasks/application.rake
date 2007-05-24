namespace :app do
  desc "Make new swap"
  task :new_swap => [:environment] do
    Swap.create :deadline => SWAP_LENGTH.from_now
    make_sets
  end
  
  desc "Populate swap with sets"
  task :make_sets => [:environment] do
    @swap = Swap.current
    @swap.initialize_set(@swap.users, SWAPSET_SIZE, Swapset.find(:all).map(&:users))
    solve.each do |users|
      swapset = swapsets.create
      users.each { |user| swapset.assign user }
    end
  end
  
end