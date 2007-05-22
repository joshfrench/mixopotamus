class ConfirmationsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def create
    assignment = Assignment.find(params[:confirmation][:assignment])
    @user = assignment.user
    Confirmation.create :from => current_user, :assignment_id => assignment.id
    render :action => "swap_mail"
   end
   
   def destroy
    confirmation = current_user.confirms_given.find_by_id(params[:id])
    @user = confirmation.assignment.user
    confirmation.destroy
    render :action => "swap_mail"
   end
  
end
