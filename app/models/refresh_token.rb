class RefreshToken < ApplicationRecord
  belongs_to :user

  scope :active, -> { where("expires_at > ?", Time.current) }

  def self.generate(user)
    raw = SecureRandom.hex(64)
    digest = BCrypt::Password.create(raw)

    token = user.refresh_tokens.create!(
      token_digest: digest,
      expires_at: 30.days.from_now
    )

    [token, raw]
  end

  def valid_token?(raw_token)
    BCrypt::Password.new(token_digest).is_password?(raw_token)
  end
end
