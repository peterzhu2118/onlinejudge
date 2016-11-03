class ContestsController < ApplicationController
  def main
    @contest = Contest.find_by(id: params[:contest_id])
    if (@contest.nil?)
      flash.now[:error] = "Cannot find contest"
      redirect_to '/panel'
    end
  end

end
