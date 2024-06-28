Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"

  authenticate :admin do
    resources :admins, only: %i[ index show ]
  end

  resources :shared_fees, only: [:show, :new, :create]
end
