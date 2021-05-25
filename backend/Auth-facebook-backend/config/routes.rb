Rails.application.routes.draw do
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      get "auth/facebook/callback", to: "auth_callbacks#facebook"
    end
  end
end
