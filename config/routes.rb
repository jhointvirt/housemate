require 'sidekiq/web'

Rails.application.routes.draw do
  mount Sidekiq::Web => '/sidekiq'
  
  namespace :api do
    namespace :v1 do
      resources :users, :rented_accommodation
      resources :rented_accommodation_response, except: [:show]
      post 'auth/login', to: 'auth#login'
      post 'auth/refresh', to: 'auth#refresh'
      post 'map/reverse_place_from_coordinate', to: 'map#reverse_place_from_coordinate'
      post 'rented_accommodation/new', to: 'rented_accommodation#new'

      get 'profile/show_by_current_user', to: 'profile#show_by_current_user'
      get 'map/show_by_place_name', to: 'map#show_by_place_name'
      get 'rented_accommodation_response/show_my_responses', to: 'rented_accommodation_response#show_my_responses'
      get 'rented_accommodation_response/get_responses_on_my_accommodation', to: 'rented_accommodation_response#get_responses_on_my_accommodation'

      put 'profile/:id', to: 'profile#update'
      put 'profile/update_avatar/:id', to: 'profile#update_avatar'
    end
  end
end
