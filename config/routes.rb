Rails.application.routes.draw do
  # =================================================================
  # 1. PLATFORM ADMIN SIDE (localhost)
  # =================================================================
  constraints(lambda { |r| r.subdomain.blank? || r.subdomain == "www" }) do
    # Wrap in scope to avoid helper name collisions
    devise_for :admins, class_name: "User", path: "admin", path_names: { sign_in: "login" }

    # Redirect default path to admin path
    get "/users/sign_in", to: redirect("/admin/login")

    resources :clients
    root to: "dashboard#index", as: :platform_root
  end

  # =================================================================
  # 2. TENANT STORE SIDE (subdomains)
  # =================================================================
  constraints(lambda { |r| r.subdomain.present? && r.subdomain != "www" }) do
    # --- FIXED SECTION ---
    # Use 'scope as: :tenant' to prefix helpers (new_tenant_user_session_path)
    # But DO NOT pass 'as: :tenant' to devise_for, so it stays as :user scope
    devise_for :users, path: "store", path_names: { sign_in: "login" }

    get "dashboard", to: "dashboard#index", as: :tenant_dashboard

    # Catch the default redirect and send it to the store login
    get "/users/sign_in", to: redirect("/store/login")

    root to: "dashboard#index"
  end
end
