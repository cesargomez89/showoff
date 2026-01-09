module Mutations
  class GoogleLogin < BaseMutation
    argument :id_token, String, required: true

    field :token, String, null: false
    field :user, Types::UserType, null: false

    def resolve(id_token:)
      data = GoogleAuthService.verify(id_token)
      raise GraphQL::ExecutionError, "Invalid Google token" unless data

      user = User.find_or_create_by!(
        email: data[:email],
        provider: "google",
        uid: data[:uid]
      )

      token = JwtService.encode(user_id: user.id)
      refresh = RefreshToken.generate(user)

      context[:response].set_cookie(
        :refresh_token,
        value: refresh,
        httponly: true,
        secure: Rails.env.production?,
        same_site: :strict,
        expires: 30.days.from_now
      )

      {
        token: token,
        user: user
      }
    end
  end
end
