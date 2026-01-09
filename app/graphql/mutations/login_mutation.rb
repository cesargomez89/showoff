module Mutations
  class Login < BaseMutation
    argument :email, String, required: true
    argument :password, String, required: true

    field :token, String, null: false
    field :user, Types::UserType, null: false

    def resolve(email:, password:)
      user = User.find_by(email: email)
      raise GraphQL::ExecutionError, "Invalid credentials" unless user&.authenticate(password)

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
