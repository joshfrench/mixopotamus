class SwapsetsController < ApplicationController
  before_filter :login_required
  
  def show
    if @set = current_user.find_swapset_by_position(1)
      # dirty hack moves an obnoxious address length 
      # to position 5 where it won't overlap another
      @users = (@set.users - [current_user]).sort_by { |u| u.address.length }
    else
      render :action => "no_set"
    end
  end
end