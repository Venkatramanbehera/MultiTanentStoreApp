class TenantMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    subdomain = request.subdomain

    # Handle localhost, www, or empty subdomains -> Public Schema
    if subdomain.blank? || subdomain == "www" || subdomain == "localhost"
      ActiveRecord::Base.connection.schema_search_path = "public"
    else
      # Tenant Schema
      begin
        # "subdomain, public" ensures we can still access shared tables if needed
        ActiveRecord::Base.connection.schema_search_path = "#{subdomain}, public"
      rescue ActiveRecord::StatementInvalid
        ActiveRecord::Base.connection.schema_search_path = "public"
      end
    end

    @app.call(env)
  end
end
