Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins

  root to: "home#index"

  resources :condos do
    resources :base_fees, only: [:new, :create, :show]
  end
end
