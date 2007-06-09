module SwapsetsHelper
  
  def other_users_in(set)
    set.users - [current_user]
  end
  
  def mini_star_for(user, set)
    render :partial => "mini_star" if current_user.favorited(user, set)
  end
  
end
