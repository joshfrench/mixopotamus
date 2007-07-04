module SwapsetsHelper
  
  def other_users_in(set)
    set.users - [current_user]
  end
  
  def mini_star_for(user, set)
    render :partial => "mini_star" if current_user.favorited?(Assignment.find_by_swapset_id_and_user_id(set.id, user.id))
  end
  
end
