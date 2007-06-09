class SwapsetsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def index
    @swapsets = current_user.swapsets - Swap.current.swapsets
    render @swapsets.empty? ? { :nothing => true } : { :layout => "past_sets" }
  end
  
  def show
    sets = current_user.swapsets.find_all_by_swap_id(Swap.current)
    @set = sets.first
    # get all users of all sets into single array
    users = sets.inject([]) { |s,u| s.concat u.users }
    # hackity hack: move an obnoxious address length 
    # to last position where it won't overlap another
    @users = (users - [current_user]).sort_by { |u| u.address.length }
  rescue
    # no sets yet? ok, skip this component
    render :nothing => true
  end

end