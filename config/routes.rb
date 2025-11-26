# Rails.application.routes.draw do
#   devise_for :users
#   resources :clients
#   # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

#   # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
#   # Can be used by load balancers and uptime monitors to verify that the app is live.
#   get "up" => "rails/health#show", as: :rails_health_check

#   # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
#   # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
#   # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

#   # Defines the root path route ("/")
#   # root "posts#index"
# end

Rails.application.routes.draw do
  # =================================================================
  # 1. PLATFORM ADMIN SIDE (localhost) - "Normal Devise"
  # =================================================================
  constraints(lambda { |r| r.subdomain.blank? || r.subdomain == "www" }) do
    # 1. Standard Devise for You
    # URL: /users/sign_in
    # Helper: new_user_session_path
    devise_for :users

    resources :clients

    # Standard root for you
    root to: "clients#index", as: :platform_root
  end

  # =================================================================
  # 2. TENANT STORE SIDE (subdomains) - "Different URL"
  # =================================================================
  constraints(lambda { |r| r.subdomain.present? && r.subdomain != "www" }) do
    # 2. Custom Devise for Tenants
    # We use 'as: :tenant' to avoid name collisions with the admin side.
    # We use 'path: 'store'' to change the URL.

    # URL: /store/login
    # Helper: new_tenant_user_session_path
    devise_for :users,
               as: :tenant,
               path: "store",
               path_names: { sign_in: "login", sign_out: "logout", sign_up: "register" }

    get "dashboard", to: "dashboard#index", as: :tenant_dashboard
    resources :products
    resources :orders

    root to: "products#index"
  end
end
