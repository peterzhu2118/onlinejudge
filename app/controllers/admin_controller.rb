class AdminController < ApplicationController
  before_action :admin_check
  
  def user
    @user = User.find_by(id: params[:id])
  end
  
   def update_user
    @user = User.find_by(id: params[:id])
    
    if @user.update(user_params)
      flash[:info] = "Updated successfully"
    else
      flash[:warning] = "Updating failed"
    end
    
    redirect_to '/admin/user/'
  end
  
  def delete_user
    # TO BE IMPLEMENTED
  end
  
  def new_user
    @user = User.new
  end
  
  def create_user    
    if (params[:user][:password].length == 0)
      flash[:error] = "Password cannot be empty"
      redirect_to request.original_url
      return
    else
      p user_params
      @user = User.new(user_params)
      if @user.save
        flash[:info] = "Added successfully"
      else
        flash[:error] = "Adding failed"
      end
      redirect_to "/admin/user/"
    end
  end
  
  private
  
  def admin_check
    unless current_user.admin?
      flash[:error] = "Access Denied"
      redirect_to "/panel"
    end
  end
  
  def user_params
    if (params[:user][:password].length > 0)  
      return params.require(:user).permit(:first_name, :last_name, :email, :password)
    else
      return params.require(:user).permit(:first_name, :last_name, :email)
    end
  end
  
  def other
    return params.require(:user).permit(:first_name, :last_name, :email, :password)
  end
end
