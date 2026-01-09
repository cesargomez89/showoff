class AuthController < ApplicationController
  def refresh
    raw_value = cookies[:refresh_token]
    return unauthorized unless raw_value

    token_id, raw_token = raw_value.split(":")
    return unauthorized unless token_id && raw_token

    refresh_token = RefreshToken.active.find_by(id: token_id)
    return unauthorized unless refresh_token&.valid_token?(raw_token)

    user = refresh_token.user

    # ROTATE TOKEN
    refresh_token.destroy
    new_refresh_obj, new_raw_token = RefreshToken.generate(user)

    cookies[:refresh_token] = {
      value: "#{new_refresh_obj.id}:#{new_raw_token}",
      httponly: true,
      secure: Rails.env.production?,
      same_site: :strict,
      expires: 30.days.from_now
    }

    render json: {
      access_token: JwtService.encode({ user_id: user.id })
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
