class SessionsController < ApplicationController
  def submission
    @submissions = Submission.where(email: current_user.email).order(created_at: :desc)
  end
  

end
