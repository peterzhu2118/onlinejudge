class ContestEndJob < ApplicationJob
  queue_as :default

  def perform(contest)
    contest.destroy
  end
end
