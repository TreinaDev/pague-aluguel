Rails.application.routes.draw do
  devise_for :property_owners, controllers: { registrations: "property_owners/registrations", sessions: "property_owners/sessions" }
  devise_for :admins, controllers: { registrations: "admins/registrations", sessions: "admins/sessions" }

  root to: "home#index"
  get 'search', to: 'home#search'
  get 'choose_profile', to: 'home#choose_profile'
  get 'find_tenant', to: 'home#find_tenant'
  get 'tenant_bill', to: 'home#tenant_bill'

  get 'server/unreachable', to: 'server#unreachable'

  resources :admins do
    get 'condos_selection', on: :member
    post 'condos_selection_post', on: :member
  end

  resources :condos, only: [:index, :show] do
    resources :common_areas, only: [:index, :show] do
      resources :common_area_fees, only: [:new, :create]
    end

    resources :base_fees, only: [:new, :create, :show, :index] do
      post 'cancel', on: :member
    end

    resources :bills, only: [:show, :index] do
      post 'accept_payment', on: :member
      post 'reject_payment', on: :member
    end

    resources :nd_certificates, only: [:index, :show, :create] do
      get 'certificate', on: :member
      get 'find_unit', on: :collection
    end

    resources :shared_fees, only: [:index, :show, :new, :create] do
      post 'cancel', on: :member
    end

    resources :single_charges, only: [:show, :new, :create, :index] do
      post 'cancel', on: :member
    end
  end

  namespace :api do
    namespace :v1 do
      resources :condos, only: [] do
        resources :common_area_fees, only: [:index]
      end
      resources :common_area_fees, only: [:show]
      resources :single_charges, only: [:create] do
        patch 'cancel', on: :member
      end
      resources :receipts, only: [:create]
      resources :bills, only: [:show]
      resources :units, only: [] do
        resources :bills, only: [:index]
      end
    end
  end

  namespace :owners do
    resources :single_charges, only: [:index, :new, :create]
  end

  resources :units, only: [:show, :index] do
    resources :rent_fees, only: [:new, :create, :edit, :update] do
      post 'deactivate', on: :member
    end
  end

  authenticate :admin do
    resources :admins, only: [:index]
  end
end
