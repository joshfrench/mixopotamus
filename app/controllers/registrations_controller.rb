class RegistrationsController < ApplicationController
  before_filter :login_required, :get_current_swap
  
  def show
    render :template => "registrations/new" unless current_user.registrations.by_swap(@swap)
  end
  
  def create
    respond_to do |format|
      format.js do
        User.find_by_id(params[:user_id]) == current_user
        @swap.register current_user
        flash.now[:confirm] = "Thanks for signing up!" 
      end
    end
  rescue
    raise "Got an unexpected user ID on Registration.create"
  end
  
  def destroy
    respond_to do |format|
      format.js do
        current_user.registrations.find_by_id(params[:id]).destroy
        flash.now[:error] = "Registration cancelled." 
      end
    end
  end
  
  protected
  def get_current_swap
    @swap = Swap.current
  end
end
