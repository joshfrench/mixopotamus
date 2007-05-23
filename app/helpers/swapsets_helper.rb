module SwapsetsHelper
  def show_set(set)
    render :partial => (set.swap.deadline < Time.now) ? "poll" : "basic"
  end
  
  def other_users_in(set)
    set.users - [current_user]
  end
end
