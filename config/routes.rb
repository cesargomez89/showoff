Rails.application.routes.draw do
  post "/graphql", to: "graphql#execute"

  get "up" => "rails/health#show", as: :rails_health_check

  post "/auth/refresh", to: "auth#refresh"
  post "/auth/logout",  to: "auth#logout"
end
