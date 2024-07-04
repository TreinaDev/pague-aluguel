Rails.application.routes.draw do
  devise_for :property_owners, controllers: { registrations: "property_owners/registrations", sessions: "property_owners/sessions" }
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"

  resources :condos, only: [:index, :show] do
    resources :common_areas, only: [:index, :show, :edit, :update]
    resources :base_fees, only: [:new, :create, :show, :index]
    get 'search', on: :collection
  end

  resources :shared_fees, only: [:index, :show, :new, :create] do 
    post 'cancel', on: :member
  end

  authenticate :admin do
    resources :admins, only: [:index, :show]
  end
end
