Rails.application.routes.draw do
  devise_for :property_owners
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"
  get 'search', to: 'home#search'
  get 'choose_profile', to: 'home#choose_profile'

  resources :condos, only: [:index, :show] do
    resources :common_areas, only: [:index, :show, :edit, :update] do
      resources :common_area_fees, only: [:new, :create]
    end
    resources :base_fees, only: [:new, :create, :show, :index]

    get 'search', on: :collection

    resources :shared_fees, only: [:index, :show, :new, :create] do
      post 'cancel', on: :member
    end
  end

  authenticate :admin do
    resources :admins, only: [:index]
  end
end
