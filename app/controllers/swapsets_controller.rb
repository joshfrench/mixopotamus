class SwapsetsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def index
    @swapsets = current_user.swapsets - Swap.current.swapsets
    render @swapsets.empty? ? { :nothing => true } : { :layout => "past_sets" }
  end
  
  def show
    sets = current_user.swapsets.find_all_by_swap_id(Swap.current)
    assignments = sets.inject([]) { |s,a| s.concat a.assignments }
    # hackity hack: move an obnoxious address length 
    # to position 5 where it won't overlap another
    @assignments = (assignments - current_user.assignments).sort_by { |a| a.user.address.length }
  rescue
    # no sets yet? ok, skip this component
    render :nothing => true
  end

end