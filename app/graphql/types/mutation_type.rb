# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :login, mutation: Mutations::Login
    field :google_login, mutation: Mutations::GoogleLogin
  end
end
