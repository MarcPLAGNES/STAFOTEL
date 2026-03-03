Rails.application.routes.draw do
  devise_for :users
  post "/csp-violation-report", to: "csp_reports#create"

  # Health
  get "up" => "rails/health#show", as: :rails_health_check

  # Pages publiques
  root "pages#home"
  get "/sitemap.xml", to: "pages#sitemap", defaults: { format: "xml" }, as: :sitemap
  get "/jobs", to: "pages#jobs"
  get "/company", to: "pages#company"
  get "/tips", to: "pages#tips"
  get "/contact", to: "contacts#new", as: :contact
  get "/privacy", to: "pages#privacy", as: :privacy
  get "/sous-traitance", to: "pages#sous_traitance", as: :sous_traitance
  get "/interim", to: "pages#interim", as: :interim

  # Tips
  resources :tips, only: [:show]

  # Contacts
  resources :contacts, only: [:new, :create]

  # Services & devis (shallow for cleaner URLs)
  resources :services, only: [:index, :show] do
    resources :quotes, only: [:new, :create], shallow: true
  end

  resources :quotes, only: [:index, :show, :destroy] do
    patch :update_status, on: :member
    resources :appointments, only: [:create], shallow: true
  end

  # Jobs & candidatures (shallow)
  resources :jobs, only: [:show, :new, :create] do
    resources :applications, only: [:new, :create], shallow: true
  end

  resources :applications, only: [:index, :show, :destroy] do
    patch :update_status, on: :member
  end

  # RDV
  resources :appointments, only: [:index, :show] do
    patch :reschedule, on: :member
    patch :update_status, on: :member
  end

  # Back-office (compagnie)
  namespace :admin do
    root "dashboard#index"
    get :demandes, to: "dashboard#index"
    delete :clear_test_data, to: "dashboard#clear_test_data"
    delete :clear_all_data, to: "dashboard#clear_all_data"
  end
end
