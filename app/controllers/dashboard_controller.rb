class DashboardController < ApplicationController
  before_action :authenticate_user!

  def index
    if platform_admin_request?
      ensure_platform_admin!

      @clients = Client.all.order(created_at: :desc)
      render :admin_index
    else

      render :tenant_index
    end
  end

  private
  def platform_admin_request?
    request.subdomain.blank? || request.subdomain == "www"
  end

  def ensure_platform_admin!
    unless current_user.platform_admin?
      sign_out current_user
      redirect_to new_platform_user_session_path, alert: "Access Denied. Admins only."
    end
  end
end
