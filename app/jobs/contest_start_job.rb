class ContestStartJob < ApplicationJob
  queue_as :default

  def perform(contest)
    contest.save
    
    ContestEndJob.set(wait_until: contest.end_time).perform_later(contest)
  end
end
