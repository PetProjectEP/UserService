class DeleteExpiredTokensJob < ApplicationJob
  queue_as :default

  def perform(*args)
    destroyed_sessions = Session.destroy_by("expires_at < ?", Time.now)

    if Rails.env.development?
      pp destroyed_sessions
    end
  end
end
