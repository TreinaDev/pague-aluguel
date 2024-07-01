Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"

  resources :condos, only: [:index, :show]

  resources :shared_fees, only: [:index, :show, :new, :create]
  
  authenticate :admin do
    resources :admins, only: %i[ index show ]
  end
end
