class AdminController < ApplicationController
  before_action :admin_check
  
  def user
 
  end
  
  private
  
  def admin_check
    unless current_user.admin?
      flash[:error] = "Access Denied"
      redirect_to "/panel.html"
    end
  end
  
  def delete_user
    # TO BE IMPLEMENTED
  end
end
