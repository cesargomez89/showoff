module AuthHelper
  def authenticate_user!
    raise GraphQL::ExecutionError, "Unauthorized" unless context[:current_user]
  end
end
