# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  include AuthenticatedSystem
  
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => 'c_is_for_cookie'
  
  before_filter :login_from_cookie # remember-me functionality
  
  protected
  def get_current_set
    @set = current_user.find_swapset_by_position(1)
  end
end
