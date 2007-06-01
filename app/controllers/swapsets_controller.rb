class SwapsetsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def index
    @swapsets = current_user.swapsets - [current_user.swapsets.find_by_swap_id(Swap.current.id)]
    render @swapsets.empty? ? { :nothing => true } : { :layout => "past_sets" }
  end
  
  def show
    @set = current_user.find_swapset_by_position(1)
    # hackity hack: move an obnoxious address length 
    # to position 5 where it won't overlap another
    @users = (@set.users - [current_user]).sort_by { |u| u.address.length }
  rescue
    # no sets yet? ok, skip this component
    render :nothing => true
  end

end