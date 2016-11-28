class SessionsController < ApplicationController
  def submission
    @submissions = Submission.where(email: current_user.email).order(created_at: :desc)
  end
  
  def edit_user
    @user = current_user
  end
  
  def update_user
    @user = User.find_by(id: current_user.id)
    if (@user.update_with_password(user_params))
      bypass_sign_in(@user)
      flash[:info] = "User updated"
    else
      flash[:info] = "Updating failed, check current password and length of new password"
    end
    
    redirect_to "/user/edit"
  end
  
  private
  
  def user_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
