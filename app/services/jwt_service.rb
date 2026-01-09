class JwtService
  SECRET = Rails.application.secret_key_base

  def self.encode(payload, exp: 15.minutes.from_now)
    payload[:exp] = exp.to_i
    JWT.encode(payload, SECRET, "HS256")
  end

  def self.decode(token)
    JWT.decode(token, SECRET, true, algorithm: "HS256")[0]
  rescue
    nil
  end
end
