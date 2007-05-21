class SwapsetsController < ApplicationController
  before_filter :login_required
  
  def show
    @set = current_user.find_swapset_by_position(1)
    @users = @set.users - [current_user]
  end
end