class SwapsetsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def index
    #@swap = Swap.current.registration_deadline < Time.now ? Swap.current : Swap.previous
    @swap = Swap.current
    @swapsets = current_user.swapsets - @swap.swapsets
    render @swapsets.empty? ? { :nothing => true } : { :layout => "past_sets" }
  end
  
  def show
    @swap = Time.now < Swap.current.registration_deadline ? Swap.previous : Swap.current
    begin
    sets = current_user.swapsets.find_all_by_swap_id(@swap.id)
    if sets.size > 0
      assignments = sets.inject([]) { |s,a| s.concat a.assignments }
      # hackity hack: move an obnoxious address length 
      # to position 5 where it won't overlap another
      @assignments = (assignments - current_user.assignments).sort_by { |a| a.user.address.length }
    else
      render :action => "no_signup"
    end
    rescue ### if this is the first swap, display nothing
      render :nothing => true
    end
  end

end