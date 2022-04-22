Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, :rented_accommodation
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'

      get 'profile/show_by_current_user', to: 'profile#show_by_current_user'

      put 'profile/:id', to: 'profile#update'
    end
  end
end
