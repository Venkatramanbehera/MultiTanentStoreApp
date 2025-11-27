class ApplicationController < ActionController::Base
  layout :determine_layout
  helper_method :current_tenant
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  def current_user
    super || current_admin
  end
  helper_method :current_user

  def authenticate_user!
    if request.subdomain.blank? || request.subdomain == "www"
      authenticate_admin!
    else
      super
    end
  end

  private
  def current_tenant
    @current_tenant ||= Client.find_by(subdomain: request.subdomain)
  end

  def determine_layout
    if devise_controller? && (resource_name == :user || resource_name == :admin)
      "application"
    elsif request.subdomain.blank? || request.subdomain == "www"
      "platform"
    else
      "tenant"
    end
  end
end
