Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :users, :rented_accommodation
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'
      post 'map/reverse_place_from_coordinate', to: 'map#reverse_place_from_coordinate'

      get 'profile/show_by_current_user', to: 'profile#show_by_current_user'
      get 'map/show_by_place_name/:place_name', to: 'map#show_by_place_name'

      put 'profile/:id', to: 'profile#update'
    end
  end
end
