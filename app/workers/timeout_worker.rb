class TimeoutWorker
  include Sidekiq::Worker
  include ApplicationHelper
  sidekiq_options retry: 3

  def perform link
    read_from_cache(link, true, 2)
  end
end
