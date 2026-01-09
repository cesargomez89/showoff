module Mutations
  class GoogleLogin < BaseMutation
    argument :id_token, String, required: true

    field :token, String, null: false
    field :user, Types::UserType, null: false

    def resolve(id_token:)
      data = GoogleAuthService.verify(id_token)
      raise GraphQL::ExecutionError, "Invalid Google token" unless data

      user = User.find_by(email: data[:email])
      if user
        user.update!(provider: "google", uid: data[:uid])
      else
        user = User.create!(
          email: data[:email],
          provider: "google",
          uid: data[:uid]
        )
      end

      token = JwtService.encode({ user_id: user.id })
      refresh_token_obj, raw_refresh_token = RefreshToken.generate(user)

      context[:response].set_cookie(
        :refresh_token,
        value: "#{refresh_token_obj.id}:#{raw_refresh_token}",
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
