class SwapsetsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def index
    @swap = Swap.current.registration_deadline < Time.now ? Swap.current : Swap.previous
    @swapsets = current_user.swapsets - @swap.swapsets
    render @swapsets.empty? ? { :nothing => true } : { :layout => "past_sets" }
  rescue ### if this is the first swap, you won't find any previous sets
    render :nothing => true
  end
  
  def show
    @swap = Swap.current.registration_deadline > Time.now ? Swap.previous : Swap.current
    begin
    sets = current_user.swapsets.find_all_by_swap_id(@swap.id)
    if sets.size > 0
      assignments = sets.inject([]) { |s,a| s.concat a.assignments }
      # hackity hack: move an obnoxious address length 
      # to position 5 where it won't overlap another
      @assignments = (assignments - current_user.assignments).sort_by { |a| a.user.address.length }
    else
      # no sets yet? ok, skip this component
      render :nothing => true
    end
    rescue ### if this is the first swap, things blow up if you don't rescue here:
      @swap = Swap.current
      retry
    end
  end

end