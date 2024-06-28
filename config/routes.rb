Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins

  root to: "home#index"

  resources :condos, only: [] do
    resources :common_areas, only: %i[ index show edit update ]
  end
  resources :shared_fees, only: %i[show new create]
end
