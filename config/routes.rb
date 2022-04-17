Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post 'auth/login', to: 'auth#login'
    end
  end
end
