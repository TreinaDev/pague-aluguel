Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root to: "home#index"

  authenticate :admin do
    resources :admins, only: [:index]
  end
end
