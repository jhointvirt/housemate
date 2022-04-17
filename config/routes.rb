Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'
    end
  end
end
