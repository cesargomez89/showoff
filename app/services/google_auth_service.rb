class GoogleAuthService
  CLIENT_ID = ENV["GOOGLE_CLIENT_ID"]

  def self.verify(id_token)
    validator = GoogleIDToken::Validator.new
    payload = validator.check(id_token, CLIENT_ID)

    {
      email: payload["email"],
      uid: payload["sub"]
    }
  rescue
    nil
  end
end
