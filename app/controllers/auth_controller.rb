class AuthController < ActionController::API
  def refresh
    raw_token = cookies[:refresh_token]
    return unauthorized unless raw_token

    refresh_token = RefreshToken.active.find do |rt|
      rt.valid_token?(raw_token)
    end

    return unauthorized unless refresh_token

    user = refresh_token.user

    # ROTATE TOKEN
    refresh_token.destroy
    new_refresh = RefreshToken.generate(user)

    cookies[:refresh_token] = {
      value: new_refresh,
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict,
      expires: 30.days.from_now
    }

    render json: {
      access_token: JwtService.encode(user_id: user.id)
    }
  end

  def logout
    cookies.delete(:refresh_token)
    render json: { success: true }
  end

  private

  def unauthorized
    render json: { error: "Unauthorized" }, status: :unauthorized
  end
end
