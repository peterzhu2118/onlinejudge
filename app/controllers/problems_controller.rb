class ProblemsController < ApplicationController
  def main
    @problem = Problem.find_by(id: params[:problem_id])
    if (@problem.nil?)
      flash.now[:error] = "Cannot find problem"
      redirect_to "/contest/params[:contest_id]"
    end
  end
end
