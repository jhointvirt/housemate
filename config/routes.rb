Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'
      post 'rented_accommodation', to: 'rented_accommodation#create'

      get 'profile/show_by_current_user', to: 'profile#show_by_current_user'

      put 'profile/:id', to: 'profile#update'
      put 'rented_accommodation/:id', to: 'rented_accommodation#update'
    end
  end
end
