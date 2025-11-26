class Client < ApplicationRecord
  validates :subdomain, presence: true, uniqueness: true

  # Trigger schema creation when a Client is created
  after_create :create_tenant
  after_destroy :drop_tenant

  private
  def create_tenant
    # Apartment::Tenant.create(subdomain)
    return unless subdomain.match?(/\A[a-z0-9]+\z/)
    # 1. Create the Schema (The "Database")
    ActiveRecord::Base.connection.execute("CREATE SCHEMA IF NOT EXISTS \"#{subdomain}\"")

    # 2. Run Migrations for this new Schema
    # We copy the structure from the standard schema
    ActiveRecord::Base.connection.schema_search_path = subdomain

    ActiveRecord::Schema.verbose = false
    load "#{Rails.root}/db/schema.rb"

    User.create!(
      email: "admin@#{subdomain}.com",
      password: "password123",
      role: :admin
    )

    # 4. Switch back
    ActiveRecord::Base.connection.schema_search_path = "public"
  rescue StandardError => e
    # If anything fails, switch back to public so the next request isn't broken
    ActiveRecord::Base.connection.schema_search_path = "public"
    raise e
  end

  def drop_tenant
    ActiveRecord::Base.connection.execute("DROP SCHEMA IF EXISTS \"#{subdomain}\" CASCADE")
  end
end
