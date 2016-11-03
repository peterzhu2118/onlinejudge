class SessionsController < ApplicationController
  def submission
    @submissions = Submission.where(email: current_user.id)
  end
  

end
