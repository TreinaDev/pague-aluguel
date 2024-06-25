Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins

  resources :shared_fees, only: [:new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"
end
