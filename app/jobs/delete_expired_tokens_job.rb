class DeleteExpiredTokensJob < ApplicationJob
  queue_as :default

  def perform(*args)
    destroyed_sessions = Session.destroy_by("expires_at < ?", Time.now)

    destroyed_sessions.each do |session|
      Rails.cache.delete(session[:id])
    end

    if Rails.env.development?
      pp destroyed_sessions
    end
  end
end
