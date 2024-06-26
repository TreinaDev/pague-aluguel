Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins

  root to: "home#index"

  resources :shared_fees, only: [:show, :new, :create]
end
