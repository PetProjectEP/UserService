class Session < ApplicationRecord
  belongs_to :user
  self.primary_key = "token" # It's a good idea to encrypt it

  before_save :assign_token, :set_expiration_date

  private
    def assign_token
      self.token = SecureRandom.uuid
    end

    def set_expiration_date
      # Change if needed
      persist_for = { years: 0, months: 0, days: 14, hours: 0, minutes: 0, seconds: 0 }
      self.expires_at = 
        Time.now + 
        persist_for[:years].years +
        persist_for[:months].months +
        persist_for[:days].days +
        persist_for[:hours].hours +
        persist_for[:minutes].minutes +
        persist_for[:seconds].seconds
    end
end
