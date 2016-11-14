class SessionsController < ApplicationController
  def submission
    @submissions = Submission.where(email: current_user.email)
  end
  

end
