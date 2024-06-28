Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins

  root to: "home#index"

  resources :condos, only: [:index, :show]

  resources :shared_fees, only: [:index, :show, :new, :create]
end
