class ConfirmationsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def create
    respond_to do |format|
      format.js do
        @assignment = Assignment.find(params[:assign])
        current_user = User.find(params[:user_id])
        current_user.confirm(@assignment)
        render :action => "swap_mail" 
      end
    end
   end
   
   def destroy
     respond_to do |format|
       format.js do
         confirmation = User.find(params[:user_id]).confirmations.find(params[:id])
         @assignment = confirmation.assignment
         confirmation.destroy
         render :action => "swap_mail"
       end
     end
   end
   
   def authorized?
    current_user == User.find(params[:user_id])
   end
  
end
