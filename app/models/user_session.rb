class UserSession < ActiveRecord::Base
  belongs_to :user
  before_validation :set_unique_key
  scope :active, -> { where("accessed_at >= ?", 2.weeks.ago).where(revoked_at: nil).includes(:user) }

  def revoke!
    self.revoked_at = Time.now
    save!
  end

  def access(request)
    self.accessed_at = Time.now
    self.ip = request.ip
    self.user_agent = request.user_agent
    if save
      {
        value: key,
        secure: Rails.env.production? || Rails.env.staging?,
        httponly: true,
        expires: 2.weeks.from_now,
      }
    else
      {}
    end
  end

  class << self
    def authenticate(key)
      self.active.find_by(key: key)
    end
  end

  private

  def set_unique_key
    self.key = SecureRandom.urlsafe_base64(32)
  end
end