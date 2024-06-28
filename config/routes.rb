Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"

  resources :condos, only: [] do
    resources :common_areas, only: [:index, :show, :edit, :update]
  end
  authenticate :admin do
    resources :admins, only: [:index, :show]
  end

  resources :shared_fees, only: [:show, :new, :create]
end
