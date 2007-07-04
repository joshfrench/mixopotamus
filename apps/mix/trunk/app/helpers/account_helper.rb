module AccountHelper
  def do_welcome
    render :partial => "account/welcome", :locals => { :user => @user }
  end
end