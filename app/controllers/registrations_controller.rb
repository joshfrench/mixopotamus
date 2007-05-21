class RegistrationsController < ApplicationController
  before_filter :login_required, :get_current_swap
  
  def show
    render :template => "registrations/new" unless @registration = current_user.registrations.find_by_swap(@swap)
  end
  
  def create
    @swap.register User.find_by_id(params[:user_id])
    flash.now[:confirm] = "Thanks for signing up!"
  end
  
  def destroy
    current_user.registrations.find_by_id(params[:id]).destroy
    flash.now[:error] = "Registration cancelled."
  end
  
  protected
  def get_current_swap
    @swap = Swap.current
  end
end
