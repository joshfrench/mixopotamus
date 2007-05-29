namespace :dev do
  desc "Add sample data"
  task :populate => [:environment] do
    User.create(:password => 'b33omber', 
                :password_confirmation => 'b33omber',
                :login => "Josh F", 
                :address => "155 23rd St\nBrooklyn, NY\n11232", 
                :email => "josh@vitamin-j.com")

    User.create(:password => 'b33omber', 
                :password_confirmation => 'b33omber',
                :login => "Anne Coperdink", 
                :address => "15 Whitestone Dr.\nSyracuse, NY\n11235", 
                :email => "anne@vitamin-j.com")

    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Furry Lewis", 
                :address => "650 President St, #2\nBrooklyn, NY 11215", 
                :email => "furry@vitamin-j.com")

    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Herbie Melville", 
                :address => "111 N. Plain St.\n#3\nIthaca, NY\n14850", 
                :email => "herbie@vitamin-j.com")

    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Morgan Mirvis", 
                :address => "48 Peachtree Road\nAthens, GA\n06459", 
                :email => "morgan@vitamin-j.com")

    User.create(:password => 'foobar', 
                :password_confirmation => 'foobar',
                :login => "Vaclav Speezl-Ganglia", 
                :address => "777 Vunderbarlongenstreetenname 2B\nBern, Bjorn, 1KS 700\nAustria", 
                :email => "speezl@vitamin-j.com")
                
    Swap.create(:deadline => 8.weeks.from_now)
    
    Swapset.create(:swap_id => 1)
    
    (1..6).each do |i|
      Registration.create(:swap_id => 1, :user_id => i)
      Assignment.create(:swapset_id => 1, :user_id => i)
    end
    
  end
  
  desc "Zap sample data"
  task :zap => [:environment] do
    [Swapset, Swap, Invite, Confirmation, Favorite, User].each do |model|
      model.find(:all).each { |member| member.destroy }
    end
  end
  
end