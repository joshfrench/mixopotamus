class ConfirmationsController < ApplicationController
  before_filter :login_required, :get_current_set
  
  def create
    respond_to do |format|
      format.js do
        assignment = Assignment.find(params[:assign])
        @user = assignment.user
        Confirmation.create :from => User.find(params[:user_id]), :assignment_id => assignment.id
        render :action => "swap_mail" 
      end
    end
   end
   
   def destroy
     respond_to do |format|
       format.js do
         confirmation = User.find(params[:user_id]).confirms_given.find_by_id(params[:id])
         @user = confirmation.assignment.user
         confirmation.destroy
         render :action => "swap_mail"
       end
     end
   end
   
   def authorized?
    current_user == User.find(params[:user_id])
   end
  
end
