Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"

  resources :common_areas, only: %i[ index ]
end
