Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: "users/registrations",
    sessions: "users/sessions",
    passwords: "users/passwords"
  }

  ActiveAdmin.routes(self)

  patch "users/account/profile", to: "users/account_profiles#update", as: :user_account_profile
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"

  get "pricing", to: "pricing#show", as: :pricing

  get "about", to: "pages#about", as: :about
  get "contact", to: "pages#contact", as: :contact
  post "contact", to: "pages#create_contact", as: :submit_contact

  get "faq", to: "pages#faq", as: :faq
  get "terms", to: "pages#terms", as: :terms
  get "privacy", to: "pages#privacy", as: :privacy

  get "feedback", to: "pages#feedback", as: :feedback
  post "feedback", to: "pages#create_feedback", as: :submit_feedback

  resources :blog_posts, only: [ :index, :show ], path: "blog", param: :slug

  resources :notifications, only: [ :index ] do
    member do
      patch :read
    end
    collection do
      patch :mark_all_read
    end
  end

  resources :payments, only: [ :index ]
  resource :subscription, only: [ :show ], controller: "subscriptions"

  resources :profiles, only: [ :index, :create, :show, :update ] do
    member do
      delete "photos/:attachment_id", to: "profiles#destroy_photo", as: :destroy_photo
    end
  end

  resources :conversations, only: [ :index, :show, :create ] do
    resources :messages, only: [ :create ]
  end
end
